#!/bin/bash

gh auth status > /dev/null 2>&1

if [ $? -ne 0 ];then
	echo "you are not Logged in to GITHUB CLI"
	exit 1
fi

read -p "Enter your Repo Name : " repo_name
if [[ -z "$repo_name" ]];then
	echo "Repo already Exists Please Create New Repo.."
	exit 1
fi

repo_path="$HOME/$repo_name"
if [[ -d "$repo_path" ]]; then
	echo "Directory $repo_path already Exists"
else
	mkdir "$repo_path" && echo "Created Directory $repo_path"
fi

cd "$repo_path" || { echo "Failed to enter $repo_path";exit 1;}

git init 
git branch -M main
echo "Initialize git repo in $repo_path with branch main"

git config user.name "Your username"
git confir user.email "Your email"

echo "Git user.name and user.email are configures Done."

echo "# $repo_name" > README.md

git add README.md
git commit -m "COMMIT IS DONE"
read -p "Make repo public/private :" visibility

visibility=${visibility:-public}

echo "Creating GitHub Repo
'$repo_name' as $visibility and pushing code.."

gh repo create "$repo_name" --"$visibility" --source=. --remote=origin --push

if [[ $? -eq 0 ]];then
	echo "Repo Created and Pushed Successfully"
else
	echo "Failed to created"
fi
