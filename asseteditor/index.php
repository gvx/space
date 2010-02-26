<?php
require('header.php');

$tc = 0;
?>
<table class="listing" cellspacing="20">
<tr>
<?php
$d = dir(BASEPATH.'source/');
$entries = array();
while (false !== ($entry = $d->read())) {
  if (substr($entry,0,1) != '.'){
    $entries[] = $entry;
  }
}
$d->close();
sort($entries, SORT_STRING);
foreach ($entries as $entry){
  if (++$tc > 5){
    echo '</tr><tr>';
    $tc = 0;
  }
  $name = substr($entry, 0, -4);
  echo '<td width="20%" align="center"><a href="info.php?name='.$name.'"><img src="thumbs/'.$name.'.png" alt="'.ucwords(str_replace('_', ' ', $name)).'" border="0"/><br/>'.ucwords(str_replace('_', ' ', $name)).'</a></td>';
}
?>
</tr>
</table>
<?php
require('footer.php');
?>