<?php


$xslpage = "theme/page.xsl";
$xslbiblio = "theme/biblio.xsl";

$template = file_get_contents("theme/template.html");

foreach (glob("pages/*.html") as $srcfile) {
  $dstfile = basename($srcfile);
  echo "$dstfile\n";
  $main = file_get_contents($srcfile);
  $html = str_replace("%main%", $main, $template);
  file_put_contents($dstfile, $html);
}


$fwpers = fopen("pers.tsv", "w");
$fwtech = fopen("tech.tsv", "w");

foreach (glob("../xml/*.xml") as $srcfile) {
  $dstname = basename($srcfile, ".xml");
  $dstfile = $dstname.".html";
  echo basename($srcfile),"\n";
  $dom = Build::dom($srcfile);
  $main = Build::transformDoc($dom, $xslpage);
  file_put_contents($dstfile, str_replace("%main%", $main, $template));
  // data
  $pers = Build::transformDoc($dom, "theme/pers.xsl", null, array('filename' => $dstname));
  fwrite($fwpers, $pers);
  $tech = Build::transformDoc($dom, "theme/tech.xsl", null, array('filename' => $dstname));
  fwrite($fwtech, $tech);
}

// file_put_contents("biblio.html", str_replace("%main%", implode("\n", $biblio), $template));


class Merveilles17
{
  /** SQLite link, maybe useful outside */
  static public $pdo;
  /** La base de données */
  static private $sqlfile = "labymots.sqlite";

  static private $create = "
PRAGMA encoding = 'UTF-8';
PRAGMA page_size = 8192;

CREATE table pers (
  -- une personne
  id          INTEGER,        -- ! rowid auto
  text        TEXT NOT NULL,  -- ! forme dans le texte
  key         TEXT,           -- ! clé
  role        TEXT,           -- ! role
  filename    TEXT NOT NULL,  -- ! nom du fichier source
  anchor      TEXT NOT NULL,  -- ! ancre dans le ficheir source
  PRIMARY KEY(id ASC)
);
CREATE INDEX pers_role ON pers(role, key, text);

  ";

}

class Build
{
  /** XSLTProcessors */
  private static $transcache = array();

  static function dom($xmlfile) {
    $dom = new DOMDocument();
    $dom->preserveWhiteSpace = false;
    $dom->formatOutput=true;
    $dom->substituteEntities=true;
    $dom->load($xmlfile, LIBXML_NOENT | LIBXML_NONET | LIBXML_NSCLEAN | LIBXML_NOCDATA | LIBXML_NOWARNING);
    return $dom;
  }
  /**
   * Xsl transform from xml file
   */
  static function transform($xmlfile, $xslfile, $dst=null, $pars=null)
  {
    return self::transformDoc(self::dom($xmlfile), $xslfile, $dst, $pars);
  }

  static public function transformXml($xml, $xslfile, $dst=null, $pars=null)
  {
    $dom = new DOMDocument();
    $dom->preserveWhiteSpace = false;
    $dom->formatOutput=true;
    $dom->substituteEntities=true;
    $dom->loadXml($xml, LIBXML_NOENT | LIBXML_NONET | LIBXML_NSCLEAN | LIBXML_NOCDATA | LIBXML_NOWARNING);
    return self::transformDoc($dom, $xslfile, $dst, $pars);
  }

  /**
   * An xslt transformer with cache
   * TOTHINK : deal with errors
   */
  static public function transformDoc($dom, $xslfile, $dst=null, $pars=null)
  {
    if (!is_a($dom, 'DOMDocument')) {
      throw new Exception('Source is not a DOM document, use transform() for a file, or transformXml() for an xml as a string.');
    }
    $key = realpath($xslfile);
    // cache compiled xsl
    if (!isset(self::$transcache[$key])) {
      $trans = new XSLTProcessor();
      $trans->registerPHPFunctions();
      // allow generation of <xsl:document>
      if (defined('XSL_SECPREFS_NONE')) $prefs = XSL_SECPREFS_NONE;
      else if (defined('XSL_SECPREF_NONE')) $prefs = XSL_SECPREF_NONE;
      else $prefs = 0;
      if(method_exists($trans, 'setSecurityPreferences')) $oldval = $trans->setSecurityPreferences($prefs);
      else if(method_exists($trans, 'setSecurityPrefs')) $oldval = $trans->setSecurityPrefs($prefs);
      else ini_set("xsl.security_prefs",  $prefs);
      $xsldom = new DOMDocument();
      $xsldom->load($xslfile);
      $trans->importStyleSheet($xsldom);
      self::$transcache[$key] = $trans;
    }
    $trans = self::$transcache[$key];
    // add params
    if(isset($pars) && count($pars)) {
      foreach ($pars as $key => $value) {
        $trans->setParameter(null, $key, $value);
      }
    }
    // return a DOM document for efficient piping
    if (is_a($dst, 'DOMDocument')) {
      $ret = $trans->transformToDoc($dom);
    }
    else if ($dst != '') {
      if (!is_dir(dirname($dst))) {
        if (!@mkdir(dirname($dst), 0775, true)) exit(dirname($dst)." impossible à créer.\n");
        @chmod(dirname($dst), 0775);  // let @, if www-data is not owner but allowed to write
      }
      $trans->transformToURI($dom, $dst);
      $ret = $dst;
    }
    // no dst file, return String
    else {
      $ret =$trans->transformToXML($dom);
    }
    // reset parameters ! or they will kept on next transform if transformer is reused
    if(isset($pars) && count($pars)) {
      foreach ($pars as $key => $value) $trans->removeParameter(null, $key);
    }
    return $ret;
  }
}


 ?>