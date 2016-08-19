#!/bin/bash
set -e

# Note above that we run dumb-init as PID 1 in order to reap zombie processes
# as well as forward signals to all processes in its session. Normally, sh
# wouldn't do either of these functions so we'd leak zombies as well as do
# unclean termination of all our sub-processes.

# If the user is trying to run bro directly with some arguments, then
# pass them to bro.
if [ "${1:0:1}" = '-' ]; then
    set -- bro "$@"
fi

# Look for bro subcommands.
if [ "$1" = 'version' ]; then
    # This needs a special case because there's no help output.
    set -- bro "$@"
elif bro --help "$1" 2>&1 | grep -q "bro $1"; then
    # We can't use the return code to check for the existence of a subcommand, so
    # we have to use grep to look for a pattern in the help output.
    set -- bro "$@"
fi

# If we are running bro, make sure it executes as the proper user.
if [ "$1" = 'bro' ]; then
    set -- gosu bro "$@"
fi

exec "$@"
