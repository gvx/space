<?php
require('header.php');

if (!isset($_GET['name'])){
  error('No asset provided for renaming.');
}
$name = strtolower(preg_replace('/[^a-z0-9_-]+/i', '', $_GET['name']));
if (!file_exists(BASEPATH.'source/'.$name.'.svg')){
  error('Unable to rename a asset that does not exist.');
}
if (!isset($_GET['newname']) || trim($_GET['newname']) == ''){
  ?>
  <form method="GET">
  Rename "<?php echo ucwords(str_replace('_', ' ', $name)); ?>" to:<br><br><br>
  <input type="hidden" name="name" value="<?php echo $name;?>" />
  <input type="text" size="50" name="newname" value="<?php echo ucwords(str_replace('_', ' ', $name)); ?>" /><br><br><br>
  <input type="submit" style="width: 325px; height: 80px;" value="Rename Asset" />
  </form>
  <?php
}else{
  $newname = strtolower(str_replace(' ', '_', preg_replace('/[^a-z0-9_ -]+/i', '', $_GET['newname'])));
  if ($newname == 'all'){
    error('The Asset name "all" is reserver for other uses.');
  }
  if (file_exists(BASEPATH.'source/'.$newname.'.svg')){
    error('The destination name already exists. Renaming failed.');
  }
  if (!rename(BASEPATH.'source/'.$name.'.svg', BASEPATH.'source/'.$newname.'.svg')){
    error('Rename failed.');
  }
  ok('Renaming of source file succesful.');
  if (!rename(BASEPATH.'exported/'.$name.'.lua', BASEPATH.'exported/'.$newname.'.lua')){
    error('Rename failed.');
  }
  ok('Renaming of exported file succesful.');
  if (!rename(BASEPATH.'thumbs/'.$name.'.png', BASEPATH.'thumbs/'.$newname.'.png')){
    error('Rename failed.');
  }
  ok('Renaming of thumbnail image succesful.');
  if (!rename(BASEPATH.'scaled/'.$name.'.png', BASEPATH.'scaled/'.$newname.'.png')){
    error('Rename failed.');
  }
  ok('Renaming of scaled image succesful.');
}

require('footer.php');
?>