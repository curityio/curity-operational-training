import axios, {AxiosRequestConfig} from 'axios';
import crypto from 'crypto'
import http from 'http';
import EventEmitter from 'node:events';
import open from 'open';

const port = 3333;
const eventEmitter = new EventEmitter();
let metadata: any;
let codeVerifier: string | null = null;
let httpServer: http.Server | null = null;

/*
 * Point to the local deployment or adjust it to point to a remote system
 */
const configuration = {
    clientId: 'console-client',
    redirectUri: `http://127.0.0.1:${port}/callback`,
    scope: 'openid purchases',
    issuer: 'https://login.demo.example/~',
};

/*
 * A basic RFC 8252 front channel implementation to test local user authentication
 */
export async function frontChannelRequest(): Promise<string> {

    await getMetadata();

    codeVerifier = generateRandomString();
    const codeChallenge = generateHash(codeVerifier);
    
    let requestUrl = metadata.authorization_endpoint;
    requestUrl += `?client_id=${encodeURIComponent(configuration.clientId)}`;
    requestUrl += `&redirect_uri=${encodeURIComponent(configuration.redirectUri)}`;
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
export async function backChannelRequest(code: string): Promise<string> {

    const formData = new URLSearchParams();
    formData.append('grant_type', 'authorization_code');
    formData.append('client_id', configuration.clientId);
    formData.append('redirect_uri', configuration.redirectUri);
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
        return response.data.access_token;

    } catch (e: any) {

        let status: number | null = null;
        if (e.response?.status) {
            status = e.response.status;
        }
        
        let code = '';
        let description = '';
        if (e.response.data) {
            
            if (e.response.data.error) {
                code = e.response.data.error;
            }

            if (e.response.data.error_description) {
                description += `: ${e.response.data.error_description}`;
            }
        }
        
        let message = 'Authorization code grant failed';
        if (status) {
            message += `, status: ${status}`;
        }
        if (code) {
            message += `, code: ${code}`;
        }
        if (description) {
            message += `, description: ${description}`;
        }
        
        throw new Error(message);
    }
}

/*
 * Utility functions
 */
async function getMetadata(): Promise<void> {

    try {
        const response = await axios(`${configuration.issuer}/.well-known/openid-configuration`);
        metadata = response.data;

    }  catch (e: any) {
        throw new Error('Unable to get metadata', e);
    }
}

function generateRandomString(): string {
    return urlEncode(crypto.randomBytes(32).toString('base64'));
}

function generateHash(data: string): string {
    
    const hash = crypto.createHash('sha256');
    hash.update(data);
    return urlEncode(hash.digest('base64'));
}

function urlEncode(data: string): string {
    return data
        .replace(/=/g, '')
        .replace(/\+/g, '-')
        .replace(/\//g, '_');
}
