<?php
$i = 1;

/* Server */
$cfg['Servers'][$i]['host'] = 'mariadb';
$cfg['Servers'][$i]['port'] = 3306;

/* Configuration storage (pmadb) */
$cfg['Servers'][$i]['controluser'] = 'pma';
$cfg['Servers'][$i]['controlpass'] = 'root';
$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';

/* TLS to MariaDB with verification */
$cfg['Servers'][$i]['ssl'] = true;
$cfg['Servers'][$i]['ssl_ca'] = '/etc/phpmyadmin/certs/ca.pem';
$cfg['Servers'][$i]['ssl_verify'] = true;
