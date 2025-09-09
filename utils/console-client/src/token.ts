import {backChannelRequest, frontChannelRequest} from './security/codeFlowClient.js';
import {introspectionRequest} from './security/introspectClient.js';


console.log('Logging in and getting access token ...')
try {

    const code = await frontChannelRequest();
    const tokens = await backChannelRequest(code);
    console.log(`Received opaque access token: ${tokens.access_token}`);

    const claims = await introspectionRequest(tokens.access_token);
    console.log('Visualizing JWT access token:');
    console.log(JSON.stringify(claims, null, 2));

} catch (e: any) {
    console.log(`Problem encountered: ${e.message}`);
}
