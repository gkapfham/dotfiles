# Gmail App Password Recovery for NeoMutt and `mailsync`

This checklist is for recovering the Gmail authentication used by NeoMutt and
`mailsync` after changing the Google Account password.

> **Public-repository security rule:** Never put a Google password, Google app
> password, recovery code, OAuth token, private key, or exported password-store
> contents in this repository. This file intentionally documents only the
> procedure and the locations of the configuration files.

## How this setup works

The local mail programs share one encrypted `pass` entry:

```text
pass entry: gkapfham@allegheny.edu
```

The entry is referenced by:

- `email/.mbsyncrc` through `PassCmd`, for IMAP downloads by `mbsync`.
- `email/.msmtprc` through `passwordeval`, for SMTP delivery by `msmtp`.
- `mutt/accounts/gkapfham@allegheny.edu.muttrc`, which tells NeoMutt to send
  through `msmtp`.

The home-directory files `~/.mbsyncrc` and `~/.msmtprc` are symlinks to the
corresponding files in this repository. Updating the one `pass` entry therefore
updates the credential used by both downloading and sending; no secret needs to
be written into a dotfile.

## Recovery procedure

### 1. Create a new Google app password

Changing the main Google Account password revokes existing app passwords.
Create a replacement at:

<https://myaccount.google.com/apppasswords>

Sign in as the mail account used by this configuration and then:

1. Complete the Google sign-in and 2-Step Verification prompts.
2. Create a new app password.
3. Use a descriptive label such as `neomutt-mbsync`.
4. Copy the generated 16-character password. Google displays it only once.
5. Keep it private and remove any display spaces before entering it into the
   password store.

An app password is not the same as the regular Google Account password. Do not
write either password in this repository or send either password through chat.

If the App Passwords page does not offer the feature, the account may be a
managed work/school account, may use security-key-only 2-Step Verification, or
may have Advanced Protection enabled. Contact the Google Workspace
administrator or use an OAuth-capable mail setup instead of disabling security
controls.

### 2. Replace the encrypted password-store entry

Run this command locally:

```sh
pass insert -m gkapfham@allegheny.edu
```

If `pass` asks to overwrite the existing entry, answer `y`. At the hidden
prompt, enter the new app password without spaces and press `Ctrl-D` when
finished.

Do not use any of these less-safe forms:

```sh
# Do not put the secret in shell history or the process list.
echo 'APP-PASSWORD' | pass insert ...

# Do not put the secret in a repository file.
password APP-PASSWORD
```

### 3. Test IMAP authentication without changing mail

First perform a dry run. It still checks the server connection and
authentication but should not modify the Maildir:

```sh
mbsync -V -y gkapfham@allegheny.edu
```

If that succeeds, run the normal synchronization:

```sh
mailsync gkapfham@allegheny.edu
```

With this configuration, `mailsync` invokes `mbsync` and then indexes the
local mail with `notmuch`. A successful run may have little output when there
are no new messages.

To synchronize every configured account instead, omit the account argument:

```sh
mailsync
```

### 4. Test SMTP delivery through NeoMutt

Start NeoMutt and send a short test message to yourself. NeoMutt uses the
configured `msmtp` account, so a successful delivery confirms the SMTP path
and app password.

The relevant SMTP configuration is:

```text
server: smtp.gmail.com
port: 465
encryption: TLS/SSL
username: the full Gmail address
credential: read from pass
```

The relevant IMAP configuration is:

```text
server: imap.gmail.com
port: 993
encryption: IMAPS
username: the full Gmail address
credential: read from pass
```

## Troubleshooting

### `535-5.7.8 Username and Password not accepted`

Check the following in order:

1. A new app password was created after the regular Google Account password
   change.
2. The app password was created for the exact account used by the mail
   configuration.
3. The value in `pass` is the new app password, not the regular Google
   password or the old app password.
4. Display spaces were removed before entering the app password.
5. No other process is currently running an old `mbsync` synchronization.

Replace the `pass` entry again if necessary. Never paste the password into a
command or into a debugging report.

### App Passwords are unavailable

For a managed Google Workspace account, the organization may restrict app
passwords or IMAP access. Verify that 2-Step Verification is enabled and ask
the Google Workspace administrator whether app passwords and IMAP are allowed.
If they are not, this password-based setup must be migrated to OAuth rather than
worked around by weakening account security.

### `mbsync` reports that it is already running

Wait for the existing synchronization to finish and retry. The `mailsync`
wrapper deliberately avoids starting a second `mbsync` process.

### Debugging warnings

Avoid `mbsync` debug modes and indiscriminately sharing `msmtp` debug output.
Mail-client protocol debugging can expose credentials or authentication data.
If detailed debugging is absolutely necessary, save it locally, inspect it for
secrets, and delete it securely afterward; never commit or paste it into an
issue or chat.

## Security maintenance

- Keep the app password only in the encrypted local `pass` store.
- Do not create a plaintext backup of the password store.
- Revoke the app password in Google Account settings when this machine or setup
  is retired.
- After changing the regular Google Account password, expect to repeat this
  checklist because Google revokes existing app passwords.
- Do not commit changes to `email/.mbsyncrc`, `email/.msmtprc`, or NeoMutt
  configuration that add a literal password.
- Keep password-store files, mailboxes, and mail logs outside this public
  repository.

## Official references

- [Google: App passwords](https://support.google.com/accounts/answer/185833)
- [Google: Add Gmail to another email client](https://support.google.com/mail/answer/7126229)
- [Google Workspace: Set up Gmail with a third-party email client](https://support.google.com/a/answer/9003945)
- [Google: Gmail IMAP and SMTP settings](https://support.google.com/mail/answer/78892)
- [`mbsync` manual](https://man.archlinux.org/man/mbsync.1.en)
- [`msmtp` manual](https://marlam.de/msmtp/msmtp.html)
