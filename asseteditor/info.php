<?php
require('header.php');

$name = preg_replace('/[^a-z0-9_-]+/i', '', $_GET['name']);
if (!file_exists(BASEPATH.'source/'.$name.'.svg')){
  error('The file you are trying to view the information for does not exist.');
}
?>
<table class="listing" cellspacing="20">
<tr>
<?php
echo '<td width="100%" align="center" colspan="3"><h2>'.ucwords(str_replace('_', ' ', $name)).'</h2></td>';
?>
</tr><tr>
<?php
echo '<td width="20%" align="center"><img src="thumbs/'.$name.'.png" alt="'.ucwords(str_replace('_', ' ', $name)).'" border="0"/></td>';
?>
<td>
<?php
echo '<pre>Filename: '.PHP_EOL.'  '.$name.'.svg'.PHP_EOL.
'Size: '.PHP_EOL.'  '.number_format(filesize(BASEPATH.'source/'.$name.'.svg')).' bytes'.PHP_EOL.
'Last modified: '.PHP_EOL.'  '.date('r', filemtime(BASEPATH.'source/'.$name.'.svg')).PHP_EOL.
PHP_EOL.'  <a href="source/'.$name.'.svg">[ Download ]</a>'.
'    <a href="upload.php?name='.$name.'">[ Re-Upload ]</a>'.
'    <a href="rename.php?name='.$name.'">[ Rename ]</a>'.PHP_EOL.
'</pre>'
?>
</td>
<td>
<?php
echo '<pre>Exported as: '.PHP_EOL.'  '.$name.'.lua'.PHP_EOL.
'Size: '.PHP_EOL.'  '.number_format(filesize(BASEPATH.'exported/'.$name.'.lua')).' bytes'.PHP_EOL.
'Last modified: '.PHP_EOL.'  '.date('r', filemtime(BASEPATH.'exported/'.$name.'.lua')).PHP_EOL.
PHP_EOL.'  <a href="exported/'.$name.'.lua">[ Download ]</a>'.
'</pre>'
?>
</td>
</tr><tr>
<?php
echo '<td width="100%" align="center" colspan="3">
<div style="float:right;border:1px solid #444;text-align: left;padding: 5px;">
  <span style="border-top:1px solid #fff;font-size: 5px;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span> &nbsp; The design<br>
  <span style="border-top:1px dotted #800;font-size: 5px;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span> &nbsp; Collision polygon<br>
</div><img src="scaled/'.$name.'.png" alt="'.ucwords(str_replace('_', ' ', $name)).'" border="0"/></td>';
?>
</tr>
</table>
<?php
require('footer.php');
?>