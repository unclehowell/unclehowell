# Email System

## Overview

System for sending email notifications from the DATRO infrastructure.

## Provider

| Field | Value |
|-------|-------|
| Provider | Resend |
| Domain | financecheque.uk |
| API Key | Stored in `.env.resend` |
| From Address | FCUK Notify <notify@financecheque.uk> |

## Usage

### Send Email via API

```bash
curl -s -X POST "https://api.resend.com/emails" \
  -H "Authorization: Bearer $RESEND_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "from": "FCUK Notify <notify@financecheque.uk>",
    "to": "recipient@example.com",
    "subject": "Subject",
    "html": "<p>Message</p>"
  }'
```

### Use in Scripts

Source the API key:
```bash
source /home/ubuntu/.env.resend
export RESEND_API_KEY
```

## Limits

- 100 emails/day (free tier)
- Custom domain required for deliverability

## Troubleshooting

- Emails going to spam: check SPF/DKIM DNS records
- Apostrophes in sender name cause issues - use plain ASCII
- Resend uses US servers but works for UK delivery

## Contact Rules

- **Only hywelapbuckler@gmail.com** receives emails from DATRO systems
- This is Hywel Buckler (system architect and creator)
- No other email addresses unless explicitly authorized by Hywel