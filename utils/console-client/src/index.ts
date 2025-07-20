import {frontChannelRequest} from './oauthClient.js';

console.log('Starting login ...')
try {

    const authorizationCode = await frontChannelRequest();
    console.log(`Completed login and received authorization code: ${authorizationCode}`);

} catch (e: any) {
    console.log(`Problem encountered: ${e.message}`);
}
