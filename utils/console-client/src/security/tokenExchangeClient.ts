import axios, {AxiosRequestConfig} from 'axios';
import {readOAuthResponseBodyError} from './utils';

/*
 * Point to the local deployment or adjust it to point to a remote system
 */
let runtimeBaseUrl = process.env.RUNTIME_BASE_URL || 'https://login.demo.example';
const configuration = {
    clientId: 'api-token-exchange-client',
    clientSecret: 'Password1',
    endpoint: `${runtimeBaseUrl}/oauth/v2/oauth-token`,
    downscope: 'openid profile',
};

/*
 * Real token exchange is an API responsibility
 * We do token exchange in this test client to enable visualization of the token data
 * This example downscopes the original access token which also removes its custom claims
 */
export async function tokenExchangeRequest(receivedJwtAccessToken: string): Promise<any> {
    
    const formData = new URLSearchParams();
    
    formData.append('grant_type', 'urn:ietf:params:oauth:grant-type:token-exchange');
    formData.append('client_id', configuration.clientId);
    formData.append('client_secret', configuration.clientSecret);
    formData.append('subject_token', receivedJwtAccessToken);
    formData.append('subject_token_type', 'urn:ietf:params:oauth:token-type:access_token');
    formData.append('requested_token_type', 'urn:ietf:params:oauth:token-type:access_token');
    formData.append('scope', configuration.downscope);

    const options = {
        url: configuration.endpoint,
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

        throw new Error(readOAuthResponseBodyError('Token exchange', e));
    }
}
