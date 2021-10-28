SHELL := /bin/bash
.PHONY: all env format analyze clean test

all: env analyze build
	
build: env
	flutter build appbundle

env:
	@sed -i "s/IOS_GOOGLE_MAPS_API_KEY/${IOS_GOOGLE_MAPS_API_KEY}/g" ios/Runner/AppDelegate.swift
	@mkdir -p assets
	@printf "${API_URI}" > assets/api_uri.txt

format:
	flutter format .

analyze:
	flutter analyze

clean:
	flutter clean

test: env
	flutter run
