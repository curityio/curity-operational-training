import {frontChannelRequest} from './security/oauthClient.js';

console.log('Starting login ...')
try {

    const code = await frontChannelRequest();
    console.log(`Completed login and received authorization code: ${code}`);

} catch (e: any) {
    console.log(`Problem encountered: ${e.message}`);
}
