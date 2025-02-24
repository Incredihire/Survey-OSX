sed -i "" "s OIDC_ISSUER_HERE $OIDC_ISSUER g " $PROJECT_DIR/AppDelegate.swift;
sed -i ""  "s OIDC_REDIRECT_URI_HERE $OIDC_REDIRECT_URI g " $PROJECT_DIR/AppDelegate.swift;
sed -i ""  "s/OIDC_CLIENT_ID_HERE/$OIDC_CLIENT_ID/g" $PROJECT_DIR/AppDelegate.swift;
sed -i ""  "s/OIDC_CLIENT_SECRET_HERE/$OIDC_CLIENT_SECRET/g" $PROJECT_DIR/AppDelegate.swift;
exit 0;
