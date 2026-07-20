import {processOAuthPostResponseError } from './utils';

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
export async function introspectionRequest(opaqueAccessToken: string, accept = 'application/json'): Promise<string> {
    
    const formData = new URLSearchParams();
    formData.append('client_id', configuration.clientId);
    formData.append('client_secret', configuration.clientSecret);
    formData.append('token', opaqueAccessToken);

    const options: RequestInit = {
        method: 'POST',
        headers: {
            accept,
            'content-type': 'application/x-www-form-urlencoded',
        },
        body: formData.toString(),
    };

    const response = await fetch(configuration.endpoint, options);
    if (!response.ok) {

        const text = await response.text();
        throw new Error(processOAuthPostResponseError('Introspection', response.status, text));
    }

    return await response.text();
}
