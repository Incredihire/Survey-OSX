sed -i ".bak" "s $SURVEY_OSX_OIDC_ISSUER SURVEY_OSX_OIDC_ISSUER_HERE g " $PROJECT_DIR/AppDelegate.swift;
sed -i ".bak" "s $SURVEY_OSX_OIDC_REDIRECT_URI SURVEY_OSX_OIDC_REDIRECT_URI_HERE g " $PROJECT_DIR/AppDelegate.swift;
sed -i ".bak" "s/$SURVEY_OSX_OIDC_CLIENT_ID/SURVEY_OSX_OIDC_CLIENT_ID_HERE/g" $PROJECT_DIR/AppDelegate.swift;
sed -i ".bak" "s/$SURVEY_OSX_OIDC_CLIENT_SECRET/SURVEY_OSX_OIDC_CLIENT_SECRET_HERE/g" $PROJECT_DIR/AppDelegate.swift;
sed -i ".bak" "s/$SURVEY_OSX_SERVER_BASE_URL/SURVEY_OSX_SERVER_BASE_URL_HERE/g" $PROJECT_DIR/Survey/Network/SurveyServer.swift;
rm "$PROJECT_DIR/AppDelegate.swift.bak"
rm "$PROJECT_DIR/Survey/Network/SurveyServer.swift.bak"
exit 0;
