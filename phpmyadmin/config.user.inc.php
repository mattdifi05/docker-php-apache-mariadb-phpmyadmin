<?php
$i = 1;

$scheme = 'http';

if (!empty($_SERVER['HTTP_X_FORWARDED_PROTO'])) {
    $scheme = (string) $_SERVER['HTTP_X_FORWARDED_PROTO'];
} elseif (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
    $scheme = 'https';
}

$host = $_SERVER['HTTP_HOST'] ?? 'localhost';
$cfg['PmaAbsoluteUri'] = sprintf('%s://%s/phpmyadmin/', $scheme, $host);

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
