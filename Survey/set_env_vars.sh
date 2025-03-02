# NOTE: please set environment variables in ~/.zshenv like example lines below before building
#export SURVEY_OSX_OIDC_ISSUER="https:\/\/accounts.google.com"
#export SURVEY_OSX_OIDC_REDIRECT_URI="com.googleusercontent.apps.0123456789012-abcdef3456g7hi89jk0lm12nop34qr5s:/auth/callback"
#export SURVEY_OSX_OIDC_CLIENT_ID="0123456789012-abcdef3456g7hi89jk0lm12nop34qr5s.apps.googleusercontent.com"
#export SURVEY_OSX_OIDC_CLIENT_SECRET="ABCDEF-GHIj0kLMN1p23QRSTuv4wxYzaBcD"
#export OSX_SURVEY_SERVER_BASE_URL="http:\/\/localhost"

sed -i ".bak" "s SURVEY_OSX_OIDC_ISSUER_HERE $SURVEY_OSX_OIDC_ISSUER g " $PROJECT_DIR/AppDelegate.swift;
sed -i ".bak"  "s SURVEY_OSX_OIDC_REDIRECT_URI_HERE $SURVEY_OSX_OIDC_REDIRECT_URI g " $PROJECT_DIR/AppDelegate.swift;
sed -i ".bak"  "s/SURVEY_OSX_OIDC_CLIENT_ID_HERE/$SURVEY_OSX_OIDC_CLIENT_ID/g" $PROJECT_DIR/AppDelegate.swift;
sed -i ".bak"  "s/SURVEY_OSX_OIDC_CLIENT_SECRET_HERE/$SURVEY_OSX_OIDC_CLIENT_SECRET/g" $PROJECT_DIR/AppDelegate.swift;
sed -i ".bak"  "s/SURVEY_OSX_SERVER_BASE_URL_HERE/$SURVEY_OSX_SERVER_BASE_URL/g" $PROJECT_DIR/Survey/Network/SurveyServer.swift;
exit 0;
