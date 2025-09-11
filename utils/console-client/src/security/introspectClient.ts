import axios, {AxiosRequestConfig} from 'axios';
import {readOAuthResponseBodyError } from './utils';

/*
 * Point to the local deployment or adjust it to point to a remote system
 */
let runtimeBaseUrl = process.env.RUNTIME_BASE_URL || 'https://login.demo.example';
const configuration = {
    clientId: 'introspect-client',
    clientSecret: 'Password1',
    endpoint: `${runtimeBaseUrl}/oauth/v2/oauth-introspect`,
};

/*
 * Real introspection is a backend API gateway responsibility
 * We do introspection in this test client to enable visualization of the token data
 */
export async function introspectionRequest(opaqueAccessToken: string, accept = 'application/json'): Promise<any> {
    
    const formData = new URLSearchParams();
    formData.append('client_id', configuration.clientId);
    formData.append('client_secret', configuration.clientSecret);
    formData.append('token', opaqueAccessToken);

    const options = {
        url: configuration.endpoint,
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            Accept: accept,
        },
        data: formData,
    } as AxiosRequestConfig;

    try {

        const response = await axios(options);
        return response.data;

    } catch (e: any) {

        throw new Error(readOAuthResponseBodyError('Introspection', e));
    }
}
