<?php
define('BASEPATH', dirname(__FILE__).'/');

function error($msg){
  ?>
  <table width="90%" cellpadding="10" style="border: 1px solid #800; margin-bottom: 5px;">
  <tr>
  <td valign="middle" width="1%"><img src="error.png" /></td>
  <td valign="middle"><?php echo $msg;?></td>
  </tr>
  </table>
  <?php
  require('footer.php');
  exit;
}

function warning($msg){
  ?>
  <table width="90%" cellpadding="10" style="border: 1px solid #840; margin-bottom: 5px;">
  <tr>
  <td valign="middle" width="1%"><img src="warning.png" /></td>
  <td valign="middle"><?php echo $msg;?></td>
  </tr>
  </table>
  <?php
}

function ok($msg){
  ?>
  <table width="90%" cellpadding="10" style="border: 1px solid #080; margin-bottom: 5px;">
  <tr>
  <td valign="middle" width="1%"><img src="ok.png" /></td>
  <td valign="middle"><?php echo $msg;?></td>
  </tr>
  </table>
  <?php
}

global $parsedata;
$parsedata = array();

function tagStart($p, $n, $att){
  global $parsedata;
  if ($n == 'PATH'){
    $parsedata[] = $att;
  }
}

function tagEnd($p, $n){}

function getCoordsFromSvg($svgdata){
  global $parsedata;
  $parsedata = array();
  $p = xml_parser_create();
  xml_set_element_handler($p, 'tagStart', 'tagEnd');
  xml_parse($p, $svgdata);
  $dat = array();
  $lines = array();
  $lc = 0;
  foreach ($parsedata as $l){
    if ($l['ID']== 'collision'){
      $lines[$lc][] = array('collision'=>true);
    }
    $tt = explode(' ', $l['D']);
    foreach ($tt as $xy){
      if ($xy == 'z'){
        $lines[$lc][] = array('closed'=>true);
      }elseif ($xy == 'm'){
        $lines[$lc][] = array('m'=>true);
      }elseif ($xy == 'M'){
        $lines[$lc][] = array('M'=>true);
      }elseif ($xy == 'l'){
        $lines[$lc][] = array('l'=>true);
      }elseif ($xy == 'L'){
        $lines[$lc][] = array('L'=>true);
      }elseif ($xy == 'h' || $xy == 'H' || $xy == 'v' || $xy == 'V'){
        echo 'Horizontal or vertical lines not supported yet.';
      }else{
        list($x, $y) = explode(',', $xy);
        $lines[$lc][] = array($x, $y);
      }
    }
    $lc++;
  }
  $newlines = array();
  $relative = false;
  $minx = $miny = 1000000000;
  $maxx = $maxy = -1000000000;
  foreach ($lines as $l => $dat){
    $cx = 0;
    $cy = 0;
    $first = true;
    foreach ($dat as $xy){
      if (isset($xy['m']) || isset($xy['l'])) $relative = true;
      if (isset($xy['M']) || isset($xy['L'])) $relative = false;
      if (isset($xy[0]) && isset($xy[1])){
        if ($relative && !$first){
          $cx += $xy[0];
          $cy += $xy[1];
        }else{
          $cx = $xy[0];
          $cy = $xy[1];
        }
        if ($cx > $maxx) $maxx = $cx;
        if ($cx < $minx) $minx = $cx;
        if ($cy > $maxy) $maxy = $cy;
        if ($cy < $miny) $miny = $cy;
        $newlines[$l][] = array($cx, $cy);
      }elseif (isset($xy['closed']) || isset($xy['collision'])){
        $newlines[$l][] = $xy;
      }
      $first = false;
    }
  }
  
  
  // calc scale
  $scale = 2 / max(array($maxx - $minx, $maxy - $miny));
  // calc offsets
  $xoffset = (($maxx - (($maxx - $minx) / 2)) * $scale)*-1;
  $yoffset = (($maxy - (($maxy - $miny) / 2)) * $scale)*-1;
/*
echo '<pre style="text-align: left;">'; print_r(array(
  '$maxx' => $maxx, 
  '$maxy' => $maxy, 
  '$minx' => $minx, 
  '$miny' => $miny, 
  '$maxx - $minx' => $maxx - $minx, 
  '$maxy - $miny' => $maxy - $miny,
  '$maxx + $minx' => $maxx + $minx,
  '$maxy + $miny' => $maxy + $miny, 
  '$scale' => $scale, 
  '$xoffset' => $xoffset, 
  '$yoffset' => $yoffset,
  '($maxx + $xoffset) * $scale' => ($maxx + $xoffset) * $scale,
  '($maxy + $yoffset) * $scale' => ($maxy + $yoffset) * $scale,
  '($minx + $xoffset) * $scale' => ($minx + $xoffset) * $scale,
  '($miny + $yoffset) * $scale' => ($miny + $yoffset) * $scale,
  '($maxx * $scale) + $xoffset' => ($maxx * $scale) + $xoffset,
  '($maxy * $scale) + $yoffset' => ($maxy * $scale) + $yoffset,
  '($minx * $scale) + $xoffset' => ($minx * $scale) + $xoffset,
  '($miny * $scale) + $yoffset' => ($miny * $scale) + $yoffset,
  )); echo '</pre>';
//*/
  $rounding = 3;
  $lines = array();
  foreach ($newlines as $l => $dat){
    foreach ($dat as $xy){
      if (isset($xy[0]) && isset($xy[1])){
        if ($xy[0] > $maxx || $xy[0] < $minx || $xy[1] > $maxy || $xy[1] < $miny){
          error('Max or min not correct.');
        }
        $lines[$l][] = array(round((($xy[0])*$scale)+$xoffset, $rounding), round((($xy[1])*$scale)+$yoffset, $rounding));
      }else{
        $lines[$l][] = $xy;
      }
    }
  }
  return $lines;
}

function export_svg($name){
// Export
  $coords = getCoordsFromSvg(file_get_contents(BASEPATH.'source/'.strtolower($name).'.svg'));
  if (count($coords) < 1){
    error('Parsing of SVG file seemed to have failed. Not coordinate data was found.');
  }
  $polys = array();
  $coll = array();
  foreach ($coords as $l => $dat){
    if (isset($dat[0]['collision'])){
      $coll = $dat;
      continue;
    }
    $polys[] = $dat;
  }
  $luadata = "return {\n";
  foreach ($polys as $l => $dat){
    $luadatat = array('width=1.5');
    foreach ($dat as $xy){
      if (isset($xy['closed'])){
        $luadatat []=  'closed=true';
      }elseif(isset($xy[0]) && isset($xy[0])){
        $luadatat []=  $xy[0].','.($xy[1] * -1);
      }
    }
    $luadata .=  '{'.implode(',', $luadatat)."},\n";
  }
  $luadatat = array();
  foreach ($coll as $xy){
    if (isset($xy[0]) && isset($xy[0])){
      $luadatat []=  $xy[0].','.($xy[1] * -1);
    }
  }
  $luadata .= 'collision = {'.implode(',', $luadatat)."},\n}\n";
  
  if (!file_put_contents(BASEPATH.'exported/'.strtolower($name).'.lua', $luadata)){
    error('Could not store the exported lua data file.');
  }
  ok('Lua data file has been succesfully stored.');
// Thumbnail
  $s = 8;
  $dim  = imagecreatetruecolor(110, 110);
  imagesavealpha($dim, true);
//	imagealphablending($dim, false);
  $trans = imagecolorallocatealpha($dim, 0, 0, 0, 127);
  imagefill($dim, 0, 0, $trans);

  $im  = imagecreatetruecolor($s*110, $s*110);
  imagesavealpha($im, true);
//	imagealphablending($im, false);
  $trans = imagecolorallocatealpha($im, 0, 0, 0, 127);
  imagefill($im, 0, 0, $trans);

  $w = imagecolorallocate($im, 255, 255, 255);
  $cc = imagecolorallocatealpha($im, 255, 0, 0, 127);
  imagesetthickness($im, $s*1.5);
  
  foreach ($coords as $l => $dat){
    $poly = array();
    $closed = false;
    $collision = false;
    foreach ($dat as $xy){
      if (isset($xy[0]) && isset($xy[1])){
        if ($xy[0] > 1 || $xy[0] < -1 || $xy[1] > 1 || $xy[1] < -1){
          warning('Coordinates out of bound. This is an error in the scaling code. x: '.$xy[0].' y:'.$xy[1]);
        }
        $poly[] = (($xy[0] * 50) + 55) * $s;
        $poly[] = (($xy[1] * 50) + 55) * $s;
      }
      if (isset($xy['closed'])) $closed = true;
      if (isset($xy['collision'])) $collision = true;
    }
    if ($closed){
      imagepolygon($im, $poly, count($poly)/2, $collision?$cc:$w);
    }else{
      for ($i = 0; $i < count($poly)-2; $i+=2){
        imageline($im, $poly[$i], $poly[$i+1], $poly[$i+2], $poly[$i+3], $collision?$cc:$w);
      }
    }
  }
  
  imagecopyresampled($dim,$im,0,0,0,0,110,110,$s*110,$s*110);
  imagepng($dim, BASEPATH.'thumbs/'.strtolower($name).'.png');
  imagedestroy($im);
  imagedestroy($dim);
  ok('Thumbnail image generated.<br><div align="center"><img src="thumbs/'.strtolower($name).'.png" border="0" alt="'.$name.'" />');
// Actual size
  if (isset($_POST['scaling'])){
    $es = floatval($_POST['scaling']);
  }else{
    $es = 1;
    if (!file_exists(BASEPATH.'scaled/'.$name.'.png')){
      warning('Could not detirmine correct scale for scaled image based on already existing image.');
    }else{
      list($w, $h) = getimagesize(BASEPATH.'scaled/'.$name.'.png');
      $es = round($w / 110, 2);
    }
  }
  $s = 8;
  $dim  = imagecreatetruecolor($es*110, $es*110);
  imagesavealpha($dim, true);
//	imagealphablending($dim, false);
  $trans = imagecolorallocatealpha($dim, 0, 0, 0, 127);
  imagefill($dim, 0, 0, $trans);

  $im  = imagecreatetruecolor($es*$s*110, $es*$s*110);
  imagesavealpha($im, true);
//	imagealphablending($im, false);
  $trans = imagecolorallocatealpha($im, 0, 0, 0, 127);
  imagefill($im, 0, 0, $trans);

  $w = imagecolorallocate($im, 255, 255, 255);
  $cc = imagecolorallocatealpha($im, 255, 0, 0, 63);
  imagesetthickness($im, $s*1.5);
  $style = array_fill(0, 200, $cc);
  $style2 = array_fill(count($style), 250, IMG_COLOR_TRANSPARENT);
  $style = array_merge($style, $style2);
  imagesetstyle($im, $style);
  
  foreach ($coords as $l => $dat){
    $poly = array();
    $closed = false;
    $collision = false;
    foreach ($dat as $xy){
      if (isset($xy[0]) && isset($xy[1])){
        if ($xy[0] > 1 || $xy[0] < -1 || $xy[1] > 1 || $xy[1] < -1){
          warning('Coordinates out of bound. This is an error in the scaling code. x: '.$xy[0].' y:'.$xy[1]);
        }
        $poly[] = (($xy[0] * 50) + 55) * $es*$s;
        $poly[] = (($xy[1] * 50) + 55) * $es*$s;
      }
      if (isset($xy['closed'])) $closed = true;
      if (isset($xy['collision'])) $collision = true;
    }
    if ($closed){
      imagepolygon($im, $poly, count($poly)/2, $collision?IMG_COLOR_STYLED:$w);
    }else{
      for ($i = 0; $i < count($poly)-2; $i+=2){
        imageline($im, $poly[$i], $poly[$i+1], $poly[$i+2], $poly[$i+3], $collision?IMG_COLOR_STYLED:$w);
      }
    }
  }
  
  imagecopyresampled($dim,$im,0,0,0,0,$es*110,$es*110,$es*$s*110,$es*$s*110);
  imagepng($dim, BASEPATH.'scaled/'.strtolower($name).'.png');
  imagedestroy($im);
  imagedestroy($dim);
  ok('Scaled image generated.<br><div align="center"><img src="scaled/'.strtolower($name).'.png" border="0" alt="'.$name.'" />');
}
?>
<html>
<head>
<title>Space - Asset Editor</title>
<style>
body{
  color: #fff;
  background-color: #000;
  margin: 20px;
  font-family: helvetica, Arial;
}
#nav ul
{
list-style: none;
padding: 0;
margin: 0;
}
#nav li
{
float: left;
margin: 0 0.15em;
} 
#nav li a{
  background-color: #222;
  height: 1.5em;
  line-height: 1.5em;
  width: 10em;
  display: block;
  border: 0.1em solid #444;
  color: #fff;
  text-decoration: none;
  text-align: center;
} 
#nav li a:hover{
  background-color: #444;
  height: 1.5em;
  line-height: 1.5em;
  float: left;
  width: 10em;
  display: block;
  border: 0.1em solid #666;
  color: #fff;
  text-decoration: none;
  text-align: center;
} 
a{
  color: #fff;
  text-decoration: none;
}
a:visited{
  color: #fff;
}
a:hover{
  color: #ccc;
  background-color: #444;
}
a:hover img{
  background-color: #000;
}
input{
  border: 1px solid #444;
  color: #fff;
  background-color: #000;
}
label {
  margin-bottom:2px;
  margin-right:3px;
  padding-left:0.5em;
  background-position:8px center;
  background-repeat:no-repeat;
  border:1px solid #444;
  clear:both;
  cursor:pointer;
  padding:0.5em 0.5em 0.5em 32px;
}
.checked{
  background-color:#222;
  background-image:url(chk_on.png)
}
.unchecked{
  background-color:#000;
  background-image:url(chk_off.png)
}
.selected{
  background-color:#222;
  background-image:url(rdo_on.png)
}
.unselected{
  background-color:#000;
  background-image:url(rdo_off.png)
}
.listing{
  width: 90%;
  border: 1px solid #444;
  background-color: #222;
}
.listing td{
  border: 1px solid #444;
  background-color: #000;
  padding: 10px;
}
h2{
  padding: 0;
  margin: 0;
}
</style>
<script type="text/javascript" src="js/mootools.js"></script>
<script type="text/javascript" src="js/moocheck.js"></script>
</head>
<body>
<table align="center"><tr><td>
<div  id="nav">
  <ul>
    <li><a href="index.php">Index</a></li>
    <li><a href="upload.php">Upload</a></li>
    <li><a href="downloadexp.php">Download Exported</a></li>
    <li><a href="downloadall.php">Download All</a></li>
    <li><a href="regenall.php">Regenerate All</a></li>
  </ul>
</div>
</td></tr></table>
<div style="position: absolute; top: 70; left: 20; bottom: 20; right: 20; border: 1px solid #444; overflow: auto;">
<table align="center" width="100%" height="100%">
<tr>
<td align="center" valign="middle">
