import {introspectionRequest} from './security/introspectClient.js';
import {backChannelRequest, downloadUserInfo, frontChannelRequest} from './security/oauthClient.js';
import {base64UrlDecode} from './security/utils.js';

console.log('Logging in and getting tokens ...')
try {

    const code = await frontChannelRequest();
    const tokens = await backChannelRequest(code);
    console.log('Received opaque access token');

    const accessTokenClaims = await introspectionRequest(tokens.access_token);
    console.log('Visualizing JWT access token:');
    console.log(JSON.stringify(accessTokenClaims, null, 2));

    console.log('Received ID token:');
    const idTokenClaims = JSON.parse(base64UrlDecode(tokens.id_token.split('.')[1]).toString());
    console.log(JSON.stringify(idTokenClaims, null, 2));

    const userInfo = await downloadUserInfo(tokens.access_token);
    console.log('Received OpenID Connect userinfo:');
    console.log(JSON.stringify(userInfo, null, 2));

} catch (e: any) {
    console.log(`Problem encountered: ${e.message}`);
}
