# Azure Container Apps Deployment

- Should have no config of its own
- Keep Docker Compose use of two .env files, which is expressive

## 1. Delete Old Config

- Update .gitignore specially for course 3
- config / configshared / vault subfolders shoud not be checked into source control

## 2. Use Course 2 Config

- Copy in course 2 configuration at runtime, deleting and recreating subfolders
- Do a replace on the config/parameters.env file using sed
- Update DB_CONNECTION, ADMIN_BASE_URL, RUNTIME_BASE_URL

## 3. Use Course 4 Config

- Minor adjustment to copy logic

## 4. Use Courses 5 and 6 Config

- Have an adjusted copy of trust.xml in a config-override folder 
- Have an IS_LOCAL variable to control whether run-crypto-tools.sh produces SSL_TRUST_STORE
