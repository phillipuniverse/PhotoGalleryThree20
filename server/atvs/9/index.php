<?php
$thumbBase = "http://www.phillipuniverse.com/three20-photo-gallery/atvs/thumbs/";
$imageBase = "http://www.phillipuniverse.com/three20-photo-gallery/atvs/" . basename(dirname(__FILE__));
$handle = opendir('.');
$photos = array();
while(false !== ($file = readdir($handle))) {
	$extension = strtolower(substr(strchr($file, '.'), 1));
	if($extension == 'jpg') {
		$photo = array();
		
		$photo['caption'] = "Cool, a caption!";
		list($thumbWidth, $thumbHeight, $thumbType, $thumbAttr) = getimagesize("../thumbs/$file");
		$photo['thumb'] = array();
		$photo['thumb']['width'] = $thumbWidth;
		$photo['thumb']['height'] = $thumbHeight;
		$photo['thumb']['url'] = $thumbBase . $file;
		
		list($largeWidth, $largeHeight, $largeType, $largeAttr) = getimagesize("./$file");
		$photo['large'] = array();
		$photo['large']['width'] = $largeWidth;
		$photo['large']['height'] = $largeHeight;
		$photo['large']['url'] = $imageBase . "/" . $file;
		
		$photos[] = $photo;
	}
}
//print_r($photos);

header("Content-type: text/xml");
echo "<?xml version=\"1.0\"?>\n";
echo "<root>\n";
foreach($photos as $photo) {
	echo "<photo>\n";
	foreach ($photo as $property => $value) {
		echo "<$property>\n";
		if(is_array($value)) {
			foreach($value as $photoProp => $photoVal) {
				echo "<$photoProp>$photoVal</$photoProp>\n";
			}
		}
		else {
			echo $value;
		}
		echo "</$property>\n";
	}
	echo "</photo>";
}
echo "</root>";
?>
