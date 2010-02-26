<?php
require('header.php');

ini_set('memory_limit', '512M');

if (!isset($_POST['up']) || $_POST['up'] != 'true'){
  $scale = 1;
  if (isset($_GET['name'])){
    $name = strtolower(preg_replace('/[^a-z0-9_-]+/i', '', $_GET['name']));
    if (!file_exists(BASEPATH.'scaled/'.$name.'.png')){
      error('Unable to re-upload a asset that does not exist.');
    }
    list($w, $h) = getimagesize(BASEPATH.'scaled/'.$name.'.png');
    $scale = round($w / 110, 2);
  }
?>
<form enctype="multipart/form-data" method="POST">
  <input type="hidden" name="up" value="true" />
  Name of the asset<br><br>
  <input type="text" size="50" name="assetname" value="<?php echo isset($_GET['name'])?ucwords(str_replace('_', ' ', $name)):'';?>" /><br><br><br>
  Suggested scaling factor<br><br>
  <input type="text" size="2" name="scaling" value="<?php echo $scale;?>" /><br><br><br>
  <label class="<?php echo isset($_GET['name'])?'checked':'unchecked';?>" style="outline-color: -moz-use-text-color; outline-style: none; outline-width: 0pt;"><input type="checkbox" name="overwrite" value="Y" <?php echo isset($_GET['name'])?'checked':'';?> />Overwrite?</label><br><br><br>
  The SVG file<br><br>
  <input name="svg" size="38" type="file" /><br><br>
  <input type="submit" style="width: 325px; height: 80px;" value="Upload Asset" />
</form>
<?php
}else{
// Store
  $name = str_replace(' ', '_', preg_replace('/[^a-z0-9_ -]+/i', '', $_POST['assetname']));
  if ($name == 'all'){
    error('The Asset name "all" is reserver for other uses.');
  }
  if (file_exists(BASEPATH.'source/'.strtolower($name).'.svg')){
    if (isset($_POST['overwrite']) && $_POST['overwrite'] == 'Y'){
      warning('Asset with that name already exists but will be overwritten.');
    }else{
      error('Asset with that name already exists.');
    }
  }
  if ($_FILES['svg']['size'] > 2 * 1024 * 1024){
    error('File size is way too large for and svg. Maximum size is 2MiB.');
  }
  if (strtolower(substr($_FILES['svg']['name'], -4)) != '.svg'){
    error('We expected a SVG file but something else was provided.');
  }
  if (!move_uploaded_file($_FILES['svg']['tmp_name'], BASEPATH.'source/'.strtolower($name).'.svg')){
    error('Failed to upload the file.');
  }
  ok('File has succesfully been uploaded.');
  export_svg($name);
}
require('footer.php');
?>