#!/bin/bash
echo """
<?php

//START CONFIG
\$CONN['user'] = '$DB_USER';
\$CONN['pass'] = '$DB_PASS';
\$CONN['server'] = '$DB_SERVER';
\$CONN['db'] = '$DB_DATABASE';
\$CONN['port'] = '$DB_PORT';

\$PEPPER = [$PEPPER];

\$INSTALL = true; //set this to true if you config the mysql and setup manually
?>
""" > /var/www/html/inc/conf.php
# start things!
apache2-foreground
