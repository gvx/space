<?php
ob_start();
require('header.php');
$h = ob_get_clean();

if (file_exists('space_all.zip')){
  unlink('space_all.zip');
}
if (file_exists(BASEPATH.'exported/all.lua')){
  unlink(BASEPATH.'exported/all.lua');
}
$d = dir(BASEPATH.'exported/');
$all = "return {\n";
while (false !== ($entry = $d->read())) {
  if (substr($entry,0,1) != '.'){
    $name = substr($entry, 0, -4);
    $all .= "\t".str_pad($name, 25, ' ', STR_PAD_RIGHT) . ' = require("'.$entry.'"),'."\n";
  }
}
$all .= "}\n";
file_put_contents(BASEPATH.'exported/all.lua', $all);
$zip = new ZipArchive;
$res = $zip->open('space_all.zip', ZipArchive::CREATE);
if ($res === TRUE) {
  foreach (array('source/', 'exported/', 'scaled/', 'thumbs/') as $dir){
    $d = dir(BASEPATH.$dir);
    while (false !== ($entry = $d->read())) {
      if (substr($entry,0,1) != '.'){
        $zip->addFile(BASEPATH.$dir.$entry, $dir.$entry);
      }
    }
  }
  $zip->close();
  if (!file_exists('space_all.zip')){
    echo $h;
    error('Failed to create the zip file.');
  }
  unlink(BASEPATH.'exported/all.lua');
  header('Expires: Sat, 26 Jul 1997 05:00:00 GMT');
  header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
  header('Content-type: application/zip;\n');
  header('Content-Transfer-Encoding: binary');
  header('Content-Length: '.filesize('space_all.zip'));
  header('Content-Disposition: attachment; filename="space_all.zip"');
  readfile('space_all.zip');
}else{
  echo $h;
  error('Failed to create zip file.');
}
?>