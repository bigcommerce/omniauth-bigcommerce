Changelog for the omniauth-bigcommerce gem.

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
