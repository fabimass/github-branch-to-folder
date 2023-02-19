# Set the GitHub repository URL and the local directory to clone to
$repoOwner = "repo-owner"
$repoName = "repo-name"

# Set the GitHub username and access token for authentication
$username = "your-username"
$accessToken = "your-personal-access-token"

#############################################################################

# Clone the repository to the local directory
git clone https://${username}:${accessToken}@github.com/${repoOwner}/${repoName}.git

# Change to the local directory
cd $repoName

# Get a list of all branches in the repository
$branches = git branch -a | where { $_ -notmatch "main" }

# Loop through each branch and create a new folder for each one
foreach ($branch in $branches) {
    # Remove the "remotes/origin/" prefix from the branch name
    $branchName = $branch -replace "remotes/origin/", ""
    $branchName = $branchName -replace "\s", ""

    # Checkout the branch
    echo "git checkout $branchName"
    git checkout $branchName

    # Create a new folder for the branch
    New-Item -ItemType Directory -Path "..\${repoName}__branches__\$branchName"

    # Copy all the files from the repository to the new folder
    echo "Copying * to ${repoName}__branches__\$branchName"
    Copy-Item * "..\${repoName}__branches__\$branchName\" -Recurse
}

# Switch back to the main branch
git checkout main