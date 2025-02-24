sed -i "" "s $OIDC_ISSUER OIDC_ISSUER_HERE g " $PROJECT_DIR/AppDelegate.swift;
sed -i "" "s $OIDC_REDIRECT_URI OIDC_REDIRECT_URI_HERE g " $PROJECT_DIR/AppDelegate.swift;
sed -i "" "s/$OIDC_CLIENT_ID/OIDC_CLIENT_ID_HERE/g" $PROJECT_DIR/AppDelegate.swift;
sed -i "" "s/$OIDC_CLIENT_SECRET/OIDC_CLIENT_SECRET_HERE/g" $PROJECT_DIR/AppDelegate.swift;
exit 0;
