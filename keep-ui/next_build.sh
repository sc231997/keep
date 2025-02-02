# This allows us to dynamically set the API_URL and NEXT_PUBLIC_API_URL based on the branch name
# This is useful for testing PRs on Vercel
if [ -n "$VERCEL_GIT_COMMIT_REF" ]; then
    branch_name_sanitized=$(echo $VERCEL_GIT_COMMIT_REF | sed 's/\//-/g' | cut -c 1-63)
    # Here we replace 'keep-api' in the URL with 'keep-api-{sanitizedBranchName}' if the branch is not main
    if [ "$branch_name_sanitized" != "main" ]; then
        export NEXT_PUBLIC_API_URL=$(echo $NEXT_PUBLIC_API_URL | sed "s|keep-api|keep-api-${branch_name_sanitized}|")
        export API_URL=$(echo $API_URL | sed "s|keep-api|keep-api-${branch_name_sanitized}|")
    fi
fi

# Then run the build
echo "Env vars:"
env
echo "Building"
next build
