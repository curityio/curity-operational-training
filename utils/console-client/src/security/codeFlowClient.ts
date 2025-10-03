import axios, {AxiosRequestConfig} from 'axios';
import getPort from 'get-port';
import http from 'http';
import EventEmitter from 'node:events';
import open from 'open';
import {generateHash, generateRandomString, readOAuthResponseBodyError} from './utils.js';

const defaultPort = 3333;
const eventEmitter = new EventEmitter();
let runtimeBaseUrl = process.env.RUNTIME_BASE_URL || 'https://login.demo.example';
let metadata: any = null;
let redirectUri: string | null = null;
let codeVerifier: string | null = null;
let httpServer: http.Server | null = null;

/*
 * Point to the local deployment or adjust it to point to a remote system
 */
const configuration = {
    clientId: 'console-client',
    scope: process.env.SCOPE || 'openid profile sales',
    issuer: `${runtimeBaseUrl}/~`,
};

/*
 * A basic RFC 8252 front channel implementation to test local user authentication
 */
export async function frontChannelRequest(): Promise<string> {

    await getMetadata();

    codeVerifier = generateRandomString();
    const codeChallenge = generateHash(codeVerifier);

    const port = await getPort({port: defaultPort});
    redirectUri = `http://127.0.0.1:${port}/callback`;

    let requestUrl = metadata.authorization_endpoint;
    requestUrl += `?client_id=${encodeURIComponent(configuration.clientId)}`;
    requestUrl += `&redirect_uri=${encodeURIComponent(redirectUri)}`;
    requestUrl += '&response_type=code';
    requestUrl += `&scope=${encodeURIComponent(configuration.scope)}`;
    requestUrl += `&code_challenge=${codeChallenge}`;
    requestUrl += '&code_challenge_method=S256';
    requestUrl += '&prompt=login';

    httpServer = http.createServer((request: http.IncomingMessage, response: http.ServerResponse) => {

        const requestUrl = new URL(request.url || '', `http://${request.headers.host}`);
        if (requestUrl.pathname !== '/callback') {
            response.end();
            return;
        }

        response.write('Console client login attempt completed - you can close this window');
        response.end();
    
        eventEmitter.emit('LOGIN_COMPLETE', requestUrl);
    });

    httpServer.listen(port);
    await open(requestUrl);

    return new Promise<string>((resolve, reject) => {

        eventEmitter.once('LOGIN_COMPLETE', (responseUrl: string) => {
            httpServer?.close();
            httpServer = null;
            
            const args = new URLSearchParams(new URL(responseUrl).search);
            const code = args.get('code') || '';
            const errorCode = args.get('error') || '';
            const errorDescription = args.get('error_description') || '';
            
            if (errorCode) {
                reject(new Error(`Authorization response error: ${errorCode}, ${errorDescription}`));
            } else if (!code) {
                reject(new Error(`Authorization response error: no authorizaton code`));
            } else {
                resolve(code);
            }
        });
    });
}

/*
 * Redeem the code for tokens
 */
export async function backChannelRequest(code: string): Promise<any> {

    const formData = new URLSearchParams();
    formData.append('grant_type', 'authorization_code');
    formData.append('client_id', configuration.clientId);
    formData.append('redirect_uri', redirectUri!);
    formData.append('code', code);
    formData.append('code_verifier', codeVerifier!);

    const options = {
        url: metadata.token_endpoint,
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            Accept: 'application/json',
        },
        data: formData,
    } as AxiosRequestConfig;

    try {

        const response = await axios(options);
        return response.data;

    } catch (e: any) {

        throw new Error(readOAuthResponseBodyError('Authorization code grant', e));
    }
}

/*
 * Use the access token to download OpenID Connect user info
 */
export async function downloadUserInfo(accessToken: string): Promise<any> {

    try {
        const options = {
            url: metadata.userinfo_endpoint,
            method: 'GET',
            headers: {
                Authorization: `Bearer ${accessToken}`,
                Accept: 'application/json',
            }
        } as AxiosRequestConfig;
        
        const response = await axios(options);
        return response.data;

    }  catch (e: any) {
        throw new Error(readOAuthResponseBodyError('Userinfo download', e));
    }
}

/*
 * Download OpenID Connect metadata
 */
async function getMetadata(): Promise<void> {

    try {
        const response = await axios(`${configuration.issuer}/.well-known/openid-configuration`);
        metadata = response.data;

    }  catch (e: any) {
        throw new Error('Unable to get metadata', e);
    }
}
