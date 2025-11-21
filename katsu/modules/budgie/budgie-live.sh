#!/bin/bash -x

# set livesys session type
sed -i 's/^livesys_session=.*/livesys_session="budgie"/' /etc/sysconfig/livesys
