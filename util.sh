#!/bin/bash

info() {
	echo "[info] $@"
}

error() {
	echo "[error] $@"
}

warn() {
	echo "[warn] $@"
}

fatal() {
	echo "[fatal] $@"
	exit 1
}

get_os_type() {
	if [[ $OSTYPE =~ "darwin" ]]; then
		echo "MacOS"
	else
		echo "Linux"
	fi
}

pkg_manager() {
	info "Identifying the package manager"
	if [ -x "$(command -v apt)" ]; then 
		PKG_MGR="apt"
	elif [ -x "$(command -v apk)" ]; then
		PKG_MGR="apk"
	else
		PKG_MGR="brew"
	fi
	info "Using package manager $PKG_MGR"
}	
