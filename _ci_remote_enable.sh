terraform remote config \
		-backend=azure \
		-backend-config="storage_account_name=${AZ_STATE_STORAGE_ACCOUNT_NAME}" \
		-backend-config="container_name=${AZ_STATE_CONTAINER_NAME}" \
		-backend-config="key=${AZ_STATE_KEY}" \
		-backend-config="access_key=${AZ_STATE_ACCESS_KEY}"