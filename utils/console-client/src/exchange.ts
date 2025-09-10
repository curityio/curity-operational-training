import {backChannelRequest, frontChannelRequest} from './security/codeFlowClient.js';
import {introspectionRequest} from './security/introspectClient.js';
import {tokenExchangeRequest} from './security/tokenExchangeClient.js';
import { base64UrlDecode } from './security/utils.js';

console.log('Logging in and getting tokens ...')
try {

    const code = await frontChannelRequest();
    const tokens = await backChannelRequest(code);

    const receivedAccessTokenJwt = await introspectionRequest(tokens.access_token, 'application/jwt');
    const receivedAccessTokenClaims = JSON.parse(base64UrlDecode(receivedAccessTokenJwt.split('.')[1]).toString());
    console.log('Received JWT access token:');
    console.log(JSON.stringify(receivedAccessTokenClaims, null, 2));

    const exchangedAccessTokenJwt = await tokenExchangeRequest(receivedAccessTokenJwt);
    const exchangedAccessTokenClaims = JSON.parse(base64UrlDecode(exchangedAccessTokenJwt.split('.')[1]).toString());
    console.log('Exchanged JWT access token:');
    console.log(JSON.stringify(exchangedAccessTokenClaims, null, 2));

} catch (e: any) {
    console.log(`Problem encountered: ${e.message}`);
}
