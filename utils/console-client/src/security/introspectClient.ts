import axios, {AxiosRequestConfig} from 'axios';

/*
 * Point to the local deployment or adjust it to point to a remote system
 */
const configuration = {
    clientId: 'introspect-client',
    clientSecret: 'Password1',
    endpoint: 'https://login.demo.example/oauth/v2/oauth-introspect',
};

/*
 * Real introspection is a backend API gateway responsibility
 * We do it in this test client for troubleshooting when getting integrated
 */
export async function introspectionRequest(opaqueAccessToken: string): Promise<any> {
    
    const formData = new URLSearchParams();
    formData.append('client_id', configuration.clientId);
    formData.append('client_secret', configuration.clientSecret);
    formData.append('token', opaqueAccessToken);

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
        return response.data;

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
        
        let message = 'Introspection request failed';
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
