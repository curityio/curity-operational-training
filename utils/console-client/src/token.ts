import {introspectionRequest} from './introspectClient.js';
import {backChannelRequest, frontChannelRequest} from './oauthClient.js';

console.log('Logging in and getting access token ...')
try {

    const code = await frontChannelRequest();
    const opaqueAccessToken = await backChannelRequest(code);
    console.log(`Received opaque access token: ${opaqueAccessToken}`);

    const claims = await introspectionRequest(opaqueAccessToken);
    console.log('Received JWT access token:');
    console.log(JSON.stringify(claims, null, 2));

} catch (e: any) {
    console.log(`Problem encountered: ${e.message}`);
}
