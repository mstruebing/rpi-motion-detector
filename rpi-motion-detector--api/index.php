<?php
header('Access-Control-Allow-Origin: *');

if (isset($_GET['token']) && $_GET['token'] === aGZYPZqeyvyAmvbHUTpvkHC9HYjEDzvh) {

/**
 * @param $string string to search in
 * @param $start string before the string to find
 * @param $end string after the string to find
 * @return bool|string found string or false if no string was found
 */
function get_string_between($string, $start, $end){
    $string = ' ' . $string;
    $ini = strpos($string, $start);
    if ($ini == 0) return '';
    $ini += strlen($start);
    $len = strpos($string, $end, $ini) - $ini;
    return substr($string, $ini, $len);
}

// Url where Images are accessible
$url = 'https://image-api.hokanhub.com/files/';
// Where to search for images
$path = '/var/www/html/image-api/files/';
// Extensions of Images
$extension = 'jpg';
// How deep to search for files
$depth = 4;
// array hold array for return
$images = [];

// Create recursive dir iterator which skips dot folders
$dir = new RecursiveDirectoryIterator($path,FilesystemIterator::SKIP_DOTS);

// Flatten the recursive iterator, folders come before their files
$it  = new RecursiveIteratorIterator($dir,RecursiveIteratorIterator::SELF_FIRST);

// Maximum depth is $depth level deeper than the base folder
$it->setMaxDepth($depth);

// Iterate through all files and folders found but skip
foreach ($it as $file) {
    // Go through every found file (skip folders) except files containing '_thumb' in name
    if ($file->isFile() && !strpos($file->getFilename(), '_thumb') && $file->getExtension() === $extension) {
        array_push($images, [
            // Filename and extension
            'name' => $file->getFilename(),
            // Full URl where to access image file
            'path' => $url.$it->getSubPath().'/'.$file->getFilename(),
            // Full URL where to access image thumbnail
            'thumbnail' => $url.$it->getSubPath().'/'.preg_replace('/\\.'.$extension.'$/', '_thumb$0', $file->getFilename()),
            // Timestamp of Image
            'timestamp' => (int)get_string_between($file->getFilename(),'_','.'),
        ]);
    }
}
// return $images json encoded
echo json_encode($images,JSON_UNESCAPED_SLASHES);
} else {
    header('HTTP/1.0 403 Forbidden');
}


