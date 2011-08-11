<?php
sleep(2);
header("Content-type: text/xml");
echo "<?xml version=\"1.0\"?>"
?>
<root>
	<album>
		<title>Soccer</title>
		<description>Or Futbol; whichever</description>
		<coverThumb>http://www.phillipuniverse/three20-photo-gallery/sports/soccer/thumbs/31_20100614151440_70_70.JPG</coverThumb>
		<photolist>http://www.phillipuniverse.com/three20-photo-gallery/sports/soccer/</photolist>
	</album>
	<album>
		<title>Football</title>
		<description>America's greatest college team</description>
		<coverThumb>http://www.phillipuniverse.com/three20-photo-gallery/sports/football/thumbs/thumb_1.jpg</coverThumb>
		<photolist>http://www.phillipuniverse.com/three20-photo-gallery/sports/football/</photolist>
	</album>
	<album>
		<title>Hockey</title>
		<description>Oh, did somebody just win the Stanley Cup? I was too busy watching the Mavs to notice</description>
		<coverThumb>http://www.phillipuniverse.com/three20-photo-gallery/sports/hockey/thumbs/wcf_sjvan4_1.jpg</coverThumb>
		<photolist>http://www.phillipuniverse.com/three20-photo-gallery/sports/hockey</photolist>
	</album>
</root>
