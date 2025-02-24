# NOTE: please set environment variables in ~/.zshenv like example lines below before building
#export OIDC_ISSUER="https:\/\/accounts.google.com"
#export OIDC_REDIRECT_URI="com.googleusercontent.apps.0123456789012-abcdef3456g7hi89jk0lm12nop34qr5s:/auth/callback"
#export OIDC_CLIENT_ID="0123456789012-abcdef3456g7hi89jk0lm12nop34qr5s.apps.googleusercontent.com"
#export OIDC_CLIENT_SECRET="ABCDEF-GHIj0kLMN1p23QRSTuv4wxYzaBcD"
sed -i "" "s OIDC_ISSUER_HERE $OIDC_ISSUER g " $PROJECT_DIR/AppDelegate.swift;
sed -i ""  "s OIDC_REDIRECT_URI_HERE $OIDC_REDIRECT_URI g " $PROJECT_DIR/AppDelegate.swift;
sed -i ""  "s/OIDC_CLIENT_ID_HERE/$OIDC_CLIENT_ID/g" $PROJECT_DIR/AppDelegate.swift;
sed -i ""  "s/OIDC_CLIENT_SECRET_HERE/$OIDC_CLIENT_SECRET/g" $PROJECT_DIR/AppDelegate.swift;
exit 0;
