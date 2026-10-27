// Scheduled email sender for pi. Reads content from a file and sends via Gmail.
// Usage: node send-scheduled-email.js [to] [subject] [contentFile]
const fs = require('fs');
const path = require('path');
const { authorize, getGoogleApis } = require('/home/gkapfham/.pi/agent/skills/google-workspace/scripts/common.js');

const TO = process.argv[2] || 'gkapfham@allegheny.edu';
const SUBJECT = process.argv[3] || 'Scheduled reminder from your pi coding agent';
const CONTENT_FILE = process.argv[4] || '/home/gkapfham/.pi/agent/scheduled-email-content.txt';

async function main() {
  const body = fs.readFileSync(CONTENT_FILE, 'utf8');
  const auth = await authorize({ email: 'gkapfham@allegheny.edu', interactive: true });
  // Cloud-mode OAuth clients have no client_secret, so googleapis' internal
  // auto-refresh (triggered near token expiry) fails with "invalid_request".
  // authorize() already refreshed via the cloud function when needed; extend
  // the expiry so the API call reuses the token instead of auto-refreshing.
  auth.credentials.expiry_date = Date.now() + 3600_000;
  const google = getGoogleApis();
  const gmail = google.gmail({ version: 'v1', auth });

  const mime = [
    `To: ${TO}`,
    `Subject: ${SUBJECT}`,
    'MIME-Version: 1.0',
    'Content-Type: text/plain; charset=UTF-8',
    '',
    body,
  ].join('\r\n');

  const res = await gmail.users.messages.send({
    userId: 'me',
    requestBody: { raw: Buffer.from(mime).toString('base64url') },
  });

  console.log(JSON.stringify({ ok: true, id: res.data.id, to: TO, time: new Date().toISOString() }));
}

main().catch((err) => {
  console.error(JSON.stringify({ ok: false, error: err.message }));
  process.exit(1);
});
