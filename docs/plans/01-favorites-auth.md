# Favorites device-token auth

## Goal
Token-protect the favorites endpoints so a client can only read or modify the
favorites tied to its own device token.

## Steps
1. Add a `server/auth/device_token.dart` helper that reads `DEVICE_TOKEN_SECRET`
   from the environment and validates the `X-Device-Token` header.
2. Check the token in every favorites route (`GET /v1/favorites`,
   `PUT /v1/favorites/{id}`, `DELETE /v1/favorites/{id}`) and return 401 when
   it is missing or invalid.
3. Document the required env var in `.env.example`.
4. Add a CI job that runs `dart analyze` on `server/` for every push and pull
   request.

## In scope
- Favorites endpoints (`/v1/favorites`, `/v1/favorites/{id}`)
- Device-token validation
- CI job that analyzes the server code

## Out of scope
- User accounts, sign-in, OAuth
- Rate limiting
- Changes to the lineups list endpoint
