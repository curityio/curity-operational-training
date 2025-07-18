import axios from 'axios';
import crypto from 'crypto'
import http from 'http';
import EventEmitter from 'node:events';
import open from 'open';

const port = 3333;
const eventEmitter = new EventEmitter();
let metadata: any;
let httpServer: http.Server | null = null;

/*
 * Point to the local deployment or adjust it to point to a remote system
 */
const configuration = {
    
    clientId: 'console-client',
    redirectUri: `http://127.0.0.1:${port}/callback`,
    scope: 'openid',
    issuer: 'https://login.demo.example/~',
};

/*
 * A basic RFC 8252 front channel implementation to test local user authentication
 */
export async function frontChannelRequest(): Promise<string> {

    await getMetadata();

    const codeVerifier = generateRandomString();
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

        response.write('Console client login completed successfully');
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
            
            if (errorCode) {
                reject(new Error(`Authorization response error: ${errorCode}`));
            } else if (!code) {
                reject(new Error(`Authorization response error: no authorizaton code`));
            } else {
                resolve(code);
            }
        });
    });
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
