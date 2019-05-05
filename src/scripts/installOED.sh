#!/bin/bash
# *
# * This Source Code Form is subject to the terms of the Mozilla Public
# * License, v. 2.0. If a copy of the MPL was not distributed with this
# * file, You can obtain one at http://mozilla.org/MPL/2.0/.
# *

USAGE="Usage: $0 [--production] [--nostart]"

production=no
dostart=yes

# Run through all flags and match
while test $# -gt 0; do
	case "$1" in
		--production)
			shift
			production=yes
			;;
		--nostart)
			shift
			dostart=no
			;;
		*)
			echo $USAGE
			exit 1
	esac
done

# Load .env if it exists

if [ -f ".env" ]; then
	source .env
fi

# Install NPM dependencies
if [ -d "node_modules" ]; then
	echo "node_modules/ exists, skipping NPM install."
else
	echo "NPM install..."
	npm install --loglevel=warn --progress=false
	echo "NPM install finished."
fi

create_error=0 # Boolean

tries=0
max_tries=10

# Try to create the schema until it succeeds
while [ $create_error == 0 ]; do
    # Sleep to let PostgreSQL chill out
    sleep 1
    echo "Attempting to create database."
    # Redirect stderr to a file
    npm run createdb |& tee /tmp/oed.error > /dev/null
    # search the file for the kind of error we can recover from
    grep -q 'Error: connect ECONNREFUSED' /tmp/oed.error
    create_error=$?

    # Check loop runtime
    ((tries=tries+1))
    if [ $tries -ge $max_tries ]; then
        echo "FAILED! Too many tries. Is your database at $OED_DB_HOST:$OED_DB_PORT down?"
        exit 1
    fi
done

echo "Schema created or already exists."

# Create a user
set -e
if [ "$production" == "no" ] && [ ! "$OED_PRODUCTION" == "yes" ]; then
    npm run createUser -- test@example.com password
	echo "Created development user 'test@example.com' with password 'password'"
fi

# Build webpack if needed
if [ "$production" == "yes" ] || [ "$OED_PRODUCTION" == "yes" ]; then
    npm run webpack:build
elif [ "$dostart" == "no" ]; then
	npm run webpack
fi

echo "OED install finished"

# Start OED
if [ "$dostart" == "yes" ]; then
	if [ "$production" == "yes" ] || [ "$OED_PRODUCTION" == "yes" ]; then
		echo "Starting OED in production mode"
		npm run start
	else
		echo "Starting OED in development mode"
		./src/scripts/devstart.sh
	fi
else
	echo "Not starting OED due to --nostart"
fi
