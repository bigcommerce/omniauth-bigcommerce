Changelog for the omniauth-bigcommerce gem.

### Pending release

### 0.7.0

- Fix `credentials` block to return the bearer token string (`access_token.token`) rather than the full `OAuth2::AccessToken` object; also restores `refresh_token`, `expires_at`, and `expires` fields that the previous override was silently dropping
- Fix `callback_url` double-prepending `script_name` in mounted Rack apps — `OmniAuth::Strategy#callback_path` already includes `script_name`, so the override no longer adds it again
- Tighten `omniauth-oauth2` lower bound to `>= 1.7.3` to prevent a Bundler `VersionConflict` with `oauth2 >= 2.0.22` for consumers that would otherwise resolve to 1.5.0–1.7.2

### 0.6.0

- Upgrade `oauth2` gem to `>= 2.0.22, < 3` to address [GHSA-pp92-crg2-gfv9](https://github.com/ruby-oauth/oauth2/security/advisories/GHSA-pp92-crg2-gfv9) (protocol-relative redirect leaking bearer tokens)
- Explicitly set `auth_scheme: :request_body` to preserve client-credential behavior across the oauth2 2.x default change to `:basic_auth`
- Drop support for Ruby < 3.3; supported versions are now Ruby 3.3, 3.4, and 4.0

### 0.5.0

- Ensure `oauth2` gem is below 2.0

### 0.4.0

- Adds account_uuid to response payload

### 0.3.3

- Add Standard BigCommerce OSS Documentation
- Upgrade `oauth2` gem to 1.4.4 or above

### 0.3.2

- Upgrade `oauth2` gem to be between 1.3.1 and 1.4.1

### 0.3.1

- Upgrade `oauth2` gem to 1.3.x
- Upgrade `omniauth-oauth2` gem to >= 1.5
- Add copyright notices
- Remove `git` cli dependency from gemspec

### 0.3.0

- Initial public release
