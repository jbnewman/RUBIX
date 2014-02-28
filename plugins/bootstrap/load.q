<?php

#Bootstrap CSS
ob_start();
?>
<link rel="stylesheet" type="text/css" href="plugins/bootstrap3/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="plugins/bootstrap3/css/font-awesome.min.css">
<!--[if IE 7]>
  <link rel="stylesheet" href="plugins/bootstrap3/css/font-awesome-ie7.min.css">
<![endif]-->
<?php
$RUBIX->css .= ob_get_contents();
ob_end_clean();



#Bootstrap JS
ob_start();
?>
<script type="text/javascript" src="plugins/bootstrap3/js/bootstrap.min.js"></script>
<?php
$RUBIX->js .= ob_get_contents();
$RUBIX->loaded[] = 'bootstrap';
ob_end_clean();

?>