<?php
if ($_GET['ajax_request']){
  include($_SERVER['DOCUMENT_ROOT'].'/inc/core.inc.php');
}


if (is_numeric($_GET['fromId']) && is_numeric($_GET['toId'])){
  $fromId=$_GET['fromId'];
  $toId=$_GET['toId'];

  if (dbCount("countryFromId=$fromId AND countryToId=$toId", "VisaInfo") == 1){

    $getVisaInfo = dbSelect("SELECT wvi.visaInfo, wvi.additionalInfo, wc.country FROM VisaInfo AS wvi, Countries AS wc WHERE wvi.countryToId = $toId AND wvi.countryFromId = $fromId AND wc.id = wvi.countryToId");
    $visaInfo=$getVisaInfo[0]['visaInfo'];
    $additionalInfo=$getVisaInfo[0]['additionalInfo'];
    $countryName=$getVisaInfo[0]['country'];

    if (strtolower($visaInfo) == "visa not required"){
       if ($additionalInfo != ""){
        $smallMessage="Stay up to $additionalInfo";
      } else {
        $smallMessage="Have a great trip!";
      }

      $bigMessage="No Visa needed! Get Packing!";
      $oneWord="NO";

    }

    elseif (strtolower($visaInfo) == "visa required"){
      if ($additionalInfo != ""){ $addThis="- Valid for $additionalInfo"; }

      $bigMessage="Yes, you need a visa!";
      $smallMessage="<a target=\"_blank\" href=\"https://www.google.com/#q=Apply+For+$countryName+Visa\">Click here</a> to find out how to apply $addThis";
      $oneWord="VISA";

    }

    elseif (strtolower($visaInfo) == "evisa"){
      if ($additionalInfo != ""){ $addThis="- Valid for $additionalInfo"; }

      $bigMessage="Yes, you need an E-Visa!";
      $smallMessage="<a target=\"_blank\" href=\"https://www.google.com/#q=Apply+For+$countryName+eVisa\">Click Here to Apply Online</a> $addThis";
      $oneWord="VISA";

    }

    elseif (strtolower($visaInfo) == "admission refused"){
      $bigMessage="Entry is not permitted";
      $smallMessage="Citizens of this country will be refused entry. Sorry :(";
      $oneWord=":(";
    }

    else {
      $bigMessage="Sorry";
      $smallMessage="There's a problem with this entry, we'll fix it ASAP!";
      $oneWord="???";
    }

?>

    <div class="clearfix search-result">
      <div style="width:25%;" class="filler-text box-position">
        <div class="one-word-answer">
          <?=$oneWord;?>
        </div>

        <div class="clearfix">
          <div style="width:55%;" class="stamp-year box-position">

            <div class="stamp">
              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Capa_1" x="0px" y="0px" viewBox="0 0 410.986 410.986" style="enable-background:new 0 0 410.986 410.986;" width="130px" xml:space="preserve">
                <g>
                  <g>
                    <path d="M355.105,118.905c-14.799,0-22.337-6.899-28.988-12.986c-6.005-5.497-10.749-9.839-20.886-9.839    c-10.137,0-14.881,4.342-20.887,9.839c-6.65,6.087-14.188,12.986-28.988,12.986c-14.8,0-22.337-6.899-28.988-12.986    c-6.005-5.497-10.748-9.839-20.885-9.839c-10.136,0-14.879,4.342-20.884,9.839c-6.65,6.087-14.188,12.986-28.988,12.986    c-14.798,0-22.334-6.899-28.984-12.986c-6.004-5.497-10.747-9.839-20.882-9.839c-10.136,0-14.879,4.342-20.884,9.839    c-6.65,6.087-14.188,12.986-28.987,12.986c-14.8,0-22.338-6.899-28.989-12.986C20.88,100.422,16.137,96.08,6,96.08    c-3.313,0-6-2.686-6-6c0-3.313,2.687-6,6-6c14.799,0,22.337,6.899,28.988,12.986c6.005,5.497,10.749,9.839,20.886,9.839    c10.136,0,14.879-4.342,20.884-9.838c6.65-6.088,14.188-12.987,28.987-12.987c14.798,0,22.335,6.9,28.985,12.987    c6.004,5.497,10.746,9.838,20.881,9.838c10.137,0,14.88-4.342,20.885-9.838c6.65-6.088,14.188-12.987,28.987-12.987    c14.8,0,22.337,6.899,28.988,12.987c6.005,5.496,10.749,9.838,20.885,9.838c10.138,0,14.881-4.342,20.886-9.838    c6.651-6.088,14.189-12.987,28.989-12.987s22.338,6.899,28.989,12.987c6.005,5.496,10.748,9.838,20.885,9.838    c10.139,0,14.883-4.342,20.89-9.839c6.651-6.087,14.19-12.986,28.991-12.986c3.313,0,6,2.687,6,6c0,3.314-2.687,6-6,6    c-10.139,0-14.883,4.342-20.89,9.839C377.445,112.006,369.907,118.905,355.105,118.905z" fill="#53687e"/>
                  </g>
                  <g>
                    <path d="M355.105,170.905c-14.799,0-22.337-6.899-28.988-12.986c-6.005-5.497-10.749-9.839-20.886-9.839    c-10.137,0-14.881,4.342-20.887,9.839c-6.65,6.087-14.188,12.986-28.988,12.986c-14.8,0-22.337-6.899-28.988-12.986    c-6.005-5.497-10.748-9.839-20.885-9.839c-10.136,0-14.879,4.342-20.884,9.839c-6.65,6.087-14.188,12.986-28.988,12.986    c-14.798,0-22.334-6.899-28.984-12.986c-6.004-5.497-10.747-9.839-20.882-9.839c-10.136,0-14.879,4.342-20.884,9.839    c-6.65,6.087-14.188,12.986-28.987,12.986c-14.8,0-22.338-6.899-28.989-12.986C20.88,152.422,16.137,148.08,6,148.08    c-3.313,0-6-2.686-6-6c0-3.313,2.687-6,6-6c14.799,0,22.337,6.899,28.988,12.986c6.005,5.497,10.749,9.839,20.886,9.839    c10.136,0,14.879-4.342,20.884-9.838c6.65-6.088,14.188-12.987,28.987-12.987c14.798,0,22.335,6.9,28.985,12.987    c6.004,5.497,10.746,9.838,20.881,9.838c10.137,0,14.88-4.342,20.885-9.838c6.65-6.088,14.188-12.987,28.987-12.987    c14.8,0,22.337,6.899,28.988,12.987c6.005,5.496,10.749,9.838,20.885,9.838c10.138,0,14.881-4.342,20.886-9.838    c6.651-6.088,14.189-12.987,28.989-12.987s22.338,6.899,28.989,12.987c6.005,5.496,10.748,9.838,20.885,9.838    c10.139,0,14.883-4.342,20.89-9.839c6.651-6.087,14.19-12.986,28.991-12.986c3.313,0,6,2.687,6,6c0,3.314-2.687,6-6,6    c-10.139,0-14.883,4.342-20.89,9.839C377.445,164.006,369.907,170.905,355.105,170.905z" fill="#53687e"/>
                  </g>
                  <g>
                    <path d="M355.105,222.906c-14.799,0-22.337-6.899-28.988-12.986c-6.005-5.497-10.749-9.839-20.886-9.839    c-10.137,0-14.881,4.342-20.887,9.838c-6.65,6.088-14.188,12.987-28.988,12.987c-14.8,0-22.337-6.899-28.988-12.987    c-6.005-5.496-10.748-9.838-20.885-9.838c-10.136,0-14.879,4.342-20.884,9.838c-6.65,6.088-14.188,12.987-28.988,12.987    c-14.798,0-22.334-6.899-28.984-12.987c-6.004-5.496-10.747-9.838-20.882-9.838c-10.136,0-14.879,4.342-20.884,9.838    c-6.65,6.088-14.188,12.987-28.987,12.987c-14.8,0-22.338-6.899-28.989-12.987c-6.005-5.496-10.749-9.838-20.885-9.838    c-3.313,0-6-2.687-6-6c0-3.314,2.687-6,6-6c14.799,0,22.337,6.899,28.988,12.986c6.005,5.497,10.749,9.839,20.886,9.839    c10.136,0,14.879-4.342,20.884-9.839c6.65-6.087,14.188-12.986,28.987-12.986c14.798,0,22.335,6.899,28.985,12.987    c6.004,5.496,10.746,9.838,20.881,9.838c10.137,0,14.88-4.342,20.885-9.839c6.65-6.087,14.188-12.986,28.987-12.986    c14.8,0,22.337,6.899,28.988,12.986c6.005,5.497,10.749,9.839,20.885,9.839c10.138,0,14.881-4.342,20.886-9.839    c6.651-6.087,14.189-12.986,28.989-12.986s22.338,6.899,28.989,12.986c6.005,5.497,10.748,9.839,20.885,9.839    c10.139,0,14.883-4.342,20.89-9.839c6.651-6.087,14.19-12.986,28.991-12.986c3.313,0,6,2.686,6,6c0,3.313-2.687,6-6,6    c-10.139,0-14.883,4.342-20.89,9.839C377.445,216.007,369.907,222.906,355.105,222.906z" fill="#53687e"/>
                  </g>
                  <g>
                    <path d="M355.105,274.906c-14.799,0-22.337-6.899-28.988-12.986c-6.005-5.497-10.749-9.839-20.886-9.839    c-10.137,0-14.881,4.342-20.887,9.838c-6.65,6.088-14.188,12.987-28.988,12.987c-14.8,0-22.337-6.899-28.988-12.987    c-6.005-5.496-10.748-9.838-20.885-9.838c-10.136,0-14.879,4.342-20.884,9.838c-6.65,6.088-14.188,12.987-28.988,12.987    c-14.798,0-22.334-6.899-28.984-12.987c-6.004-5.496-10.747-9.838-20.882-9.838c-10.136,0-14.879,4.342-20.884,9.838    c-6.65,6.088-14.188,12.987-28.987,12.987c-14.8,0-22.338-6.899-28.989-12.987c-6.005-5.496-10.749-9.838-20.885-9.838    c-3.313,0-6-2.687-6-6c0-3.314,2.687-6,6-6c14.799,0,22.337,6.899,28.988,12.986c6.005,5.497,10.749,9.839,20.886,9.839    c10.136,0,14.879-4.342,20.884-9.839c6.65-6.087,14.188-12.986,28.987-12.986c14.798,0,22.335,6.899,28.985,12.987    c6.004,5.496,10.746,9.838,20.881,9.838c10.137,0,14.88-4.342,20.885-9.839c6.65-6.087,14.188-12.986,28.987-12.986    c14.8,0,22.337,6.899,28.988,12.986c6.005,5.497,10.749,9.839,20.885,9.839c10.138,0,14.881-4.342,20.886-9.839    c6.651-6.087,14.189-12.986,28.989-12.986s22.338,6.899,28.989,12.986c6.005,5.497,10.748,9.839,20.885,9.839    c10.139,0,14.883-4.342,20.89-9.839c6.651-6.087,14.19-12.986,28.991-12.986c3.313,0,6,2.686,6,6c0,3.313-2.687,6-6,6    c-10.139,0-14.883,4.342-20.89,9.839C377.445,268.007,369.907,274.906,355.105,274.906z" fill="#53687e"/>
                  </g>
                  <g>
                    <path d="M355.105,326.906c-14.799,0-22.337-6.899-28.988-12.986c-6.005-5.497-10.749-9.839-20.886-9.839    c-10.137,0-14.881,4.342-20.887,9.838c-6.65,6.088-14.188,12.987-28.988,12.987c-14.8,0-22.337-6.899-28.988-12.987    c-6.005-5.496-10.748-9.838-20.885-9.838c-10.136,0-14.879,4.342-20.884,9.838c-6.65,6.088-14.188,12.987-28.988,12.987    c-14.798,0-22.334-6.899-28.984-12.987c-6.004-5.496-10.747-9.838-20.882-9.838c-10.136,0-14.879,4.342-20.884,9.838    c-6.65,6.088-14.188,12.987-28.987,12.987c-14.8,0-22.338-6.899-28.989-12.987c-6.005-5.496-10.749-9.838-20.885-9.838    c-3.313,0-6-2.687-6-6c0-3.315,2.687-6,6-6c14.799,0,22.337,6.899,28.988,12.986c6.005,5.497,10.749,9.839,20.886,9.839    c10.136,0,14.879-4.342,20.884-9.839c6.65-6.087,14.188-12.986,28.987-12.986c14.798,0,22.335,6.899,28.985,12.987    c6.004,5.496,10.746,9.838,20.881,9.838c10.137,0,14.88-4.342,20.885-9.839c6.65-6.087,14.188-12.986,28.987-12.986    c14.8,0,22.337,6.899,28.988,12.986c6.005,5.497,10.749,9.839,20.885,9.839c10.138,0,14.881-4.342,20.886-9.839    c6.651-6.087,14.189-12.986,28.989-12.986s22.338,6.899,28.989,12.986c6.005,5.497,10.748,9.839,20.885,9.839    c10.139,0,14.883-4.342,20.89-9.839c6.651-6.087,14.19-12.986,28.991-12.986c3.313,0,6,2.685,6,6c0,3.313-2.687,6-6,6    c-10.139,0-14.883,4.342-20.89,9.839C377.445,320.007,369.907,326.906,355.105,326.906z" fill="#53687e"/>
                  </g>
                </g>
              </svg>
            </div>
            <div class="year"><?=date("Y");?></div>
          </div>

          <div style="width:45%;" class="country box-position">
            <?=substr($countryName, 0, 2);?>
          </div>

        </div>
      </div>

      <div style="width:75%;" class="result-explanation box-position">
        <h2><?=$bigMessage;?></h2>
        <h4><?=$smallMessage;?></h4>
      </div>
    </div>

<?php
  } else {
    echo "<div class=\"no-data\">We don't have any data on this selection!</div>";
  }
}
?>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-92822223-1', 'auto');
  ga('send', 'pageview');
</script>

