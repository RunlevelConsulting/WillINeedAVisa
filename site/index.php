<?php
include($_SERVER['DOCUMENT_ROOT'].'/inc/core.inc.php');

if ( is_numeric($_GET['fromId']) ){
  $fromId = $_GET['fromId'];
  if ( dbCount("id=$fromId", "Countries") == 1 ){
    $workingFromId = 1;
    $getFromCountryDB = dbSelect("SELECT country FROM Countries WHERE id = $fromId");
    foreach($getFromCountryDB as $data){
      $countryFromName = $data['country'];
    }
  }
}

if ( is_numeric($_GET['toId']) ){
  $toId = $_GET['toId'];
  if ( dbCount("id=$toId", "Countries") == 1 ){
    $workingToId = 1;
    $getToCountryDB = dbSelect("SELECT country FROM Countries WHERE id = $toId");
    foreach($getToCountryDB as $data){
      $countryToName = $data['country'];
    }
  }
}
?>



<!doctype html>

<html lang="en">
<head>
  <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
  <meta charset="utf-8">
  <title><?php if (($workingToId == 1) && ($workingFromId == 1)){echo "$countryFromName to $countryToName | ";}?>Will I Need A Visa?</title>
  <meta name="description" content="Do you need a visa before you travel or are you good-to-go? Find out quickly at WillINeedAVisa.com!">
  <meta name="author" content="">
  <meta name="viewport" content="width=device-width" />
  <link rel="shortcut icon" type="image/x-icon" href="favicon.png">
  <link href="https://fonts.googleapis.com/css?family=Fjalla+One" rel="stylesheet">
  <link rel="stylesheet" href="mainStyles.css"/>

  <!--[if lt IE 9]>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.js"></script>
  <![endif]-->
</head>

<body>

  <div class="content-wrapper">
    <div class="content-main">
      <h1 class="title-primary">Will I need a visa?</h1>
      <form method="GET" action="/">
        <div class="option-select">

          <div class="">
            <p class="option-info">My nationality is</p>

            <select id="select-nationality" class="primary" name="fromId">
              <option disabled selected>Select Country</option>
              <?php
              $dbCountries = dbSelect("SELECT * FROM Countries ORDER BY country ASC");
                foreach($dbCountries as $data){ ?>
                  <option value="<?= $data['id']; ?>" <?php if ($fromId == $data['id']){echo " selected";}?>><?= $data['country']; ?></option>
                <?php } ?>
            </select>

          </div>

          <div class="">
            <p class="divider">AND</p>

            <svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 509.987 509.987" width="50px" class="cloud one" style="fill: rgb(83, 104, 126);" xml:space="preserve">
              <g style="fill: rgb(83, 104, 126);">
                <g id="Cloud__x2B__Sun" style="fill: rgb(83, 104, 126);">
                  <g style="fill: rgb(83, 104, 126);">
                    <path d="M439.104,286.625c-9.183-67.617-53.536-117.026-123.716-117.026c-58.751,0-91.29,34.602-111.335,88.32     c-7.324-1.746-14.852-2.63-22.448-2.63c-52.493,0-95.122,44.67-95.122,95.939c0,49.046,41.087,87.866,91.562,90.814h251.807     c43.763,0,80.134-36.734,80.134-79.476C509.964,323.019,479.058,290.797,439.104,286.625z M429.853,419.343H178.045     c-36.439-2.131-68.683-32.471-68.683-68.116c0-37.255,34.081-70.565,72.243-70.565c8.934,0,17.687,1.701,26.054,4.989     l13.809,5.487l3.696-14.036c12.925-49.069,38.412-84.805,90.224-84.805c60.86,0,96.097,48.026,98.818,107.48l0.59,12.902     l15.782-1.111c29.432,0,56.484,22.267,56.484,51.019C487.085,391.339,459.285,419.343,429.853,419.343z M184.009,152.366     c19.886,0,38.321,5.918,54.012,15.759c6.78-4.989,14.104-9.183,22.154-12.426c-21.088-16.235-47.482-26.008-76.188-26.008     c-68.66,0-124.532,55.418-124.532,123.511c0,17.868,3.923,34.806,10.839,50.157c3.787-9.478,9.07-18.095,15.351-26.031     c-1.95-7.778-3.265-15.782-3.265-24.126C82.379,197.603,127.956,152.366,184.009,152.366z M184.938,106.154     c6.394,0,12.63,0.612,18.775,1.519h1.292l-20.068-39.727l-20.09,39.727h1.292C172.286,106.789,178.521,106.154,184.938,106.154z      M40.067,273.043v-1.292c-0.907-6.1-1.519-12.29-1.519-18.616c0-6.349,0.612-12.517,1.519-18.616v-1.292L0,253.134     L40.067,273.043z M63.445,170.937c3.696-4.943,7.664-9.75,12.199-14.24c4.512-4.49,9.365-8.412,14.353-12.109l0.907-0.907     l-42.516-14.013l14.127,42.176L63.445,170.937z" style="fill: rgb(83, 104, 126);"></path>
                  </g>
                </g>
              </g>
            </svg>

            <svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 419.49 419.49" width="40px" class="cloud two" style="fill: rgb(83, 104, 126);" xml:space="preserve">
              <g style="fill: rgb(83, 104, 126);">
                <g id="Cloud" style="fill: rgb(83, 104, 126);">
                  <g style="fill: rgb(83, 104, 126);">
                    <path d="M349.288,190.562c-9.093-67.527-53.014-116.868-122.536-116.868c-58.207,0-90.428,34.557-110.292,88.206     c-7.233-1.746-14.716-2.63-22.244-2.63C42.221,159.27,0,203.895,0,255.095c0,48.978,40.702,87.753,90.701,90.701h249.427     c43.355,0,79.363-36.666,79.363-79.363C419.49,226.91,388.879,194.734,349.288,190.562z M340.127,323.121H90.701     c-36.099-2.131-68.025-32.425-68.025-68.025c0-37.21,33.763-70.452,71.54-70.452c8.843,0,17.528,1.678,25.804,4.989l13.673,5.487     l3.673-14.059c12.811-49.001,38.049-84.692,89.385-84.692c60.293,0,95.19,47.958,97.889,107.344l0.59,12.879l15.646-1.111     c29.16,0,55.962,22.244,55.962,50.951C396.815,295.14,369.287,323.121,340.127,323.121z" style="fill: rgb(83, 104, 126);"></path>
                  </g>
                </g>
              </g>
            </svg>

            <div class="animated-plane">
              <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" width="75px" style="fill: rgb(83, 104, 126);" xml:space="preserve" class="animated bounce">
                <g style="fill: rgb(83, 104, 126);">
                  <g style="fill: rgb(83, 104, 126);">
                    <g style="fill: rgb(83, 104, 126);">
                      <path d="M128,443.733H93.867c-4.71,0-8.533,3.823-8.533,8.533s3.823,8.533,8.533,8.533H128c4.71,0,8.533-3.823,8.533-8.533     S132.71,443.733,128,443.733z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M128,392.533H42.667c-4.71,0-8.533,3.823-8.533,8.533s3.823,8.533,8.533,8.533H128c4.71,0,8.533-3.823,8.533-8.533     S132.71,392.533,128,392.533z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M128,341.333H76.8c-4.71,0-8.533,3.823-8.533,8.533S72.09,358.4,76.8,358.4H128c4.71,0,8.533-3.823,8.533-8.533     S132.71,341.333,128,341.333z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M93.867,119.467H128c4.71,0,8.533-3.823,8.533-8.533c0-4.71-3.823-8.533-8.533-8.533H93.867     c-4.71,0-8.533,3.823-8.533,8.533C85.333,115.644,89.156,119.467,93.867,119.467z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M179.2,136.533c4.71,0,8.533-3.823,8.533-8.533V68.267h38.665c1.041,0,3.686,1.493,4.702,3.806l25.6,59.307     c1.391,3.226,4.531,5.154,7.834,5.154c1.135,0,2.278-0.222,3.379-0.7c4.326-1.869,6.323-6.886,4.454-11.213L246.75,65.271     c-3.567-8.158-12.126-14.071-20.352-14.071h-38.665c-9.412,0-17.067,7.842-17.067,17.493V128     C170.667,132.71,174.49,136.533,179.2,136.533z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M187.733,204.8c0-9.412-7.654-17.067-17.067-17.067c-9.412,0-17.067,7.654-17.067,17.067s7.654,17.067,17.067,17.067     C180.079,221.867,187.733,214.212,187.733,204.8z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M110.933,68.267H128c4.71,0,8.533-3.823,8.533-8.533c0-4.71-3.823-8.533-8.533-8.533h-17.067     c-4.71,0-8.533,3.823-8.533,8.533C102.4,64.444,106.223,68.267,110.933,68.267z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M324.267,187.733c-9.412,0-17.067,7.654-17.067,17.067s7.654,17.067,17.067,17.067c9.412,0,17.067-7.654,17.067-17.067     S333.679,187.733,324.267,187.733z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M349.867,290.133h102.4c4.71,0,8.533-3.823,8.533-8.533s-3.823-8.533-8.533-8.533h-102.4     c-4.71,0-8.533,3.823-8.533,8.533S345.156,290.133,349.867,290.133z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M102.4,204.8c0,9.412,7.654,17.067,17.067,17.067s17.067-7.654,17.067-17.067s-7.654-17.067-17.067-17.067     S102.4,195.388,102.4,204.8z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M290.133,204.8c0-9.412-7.654-17.067-17.067-17.067c-9.412,0-17.067,7.654-17.067,17.067s7.654,17.067,17.067,17.067     C282.479,221.867,290.133,214.212,290.133,204.8z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M459.213,205.201c-5.581-20.881-22.733-51.601-58.146-51.601H69.111l-14.874-37.171     c-3.191-8.388-11.273-14.029-20.104-14.029H17.067C7.654,102.4,0,110.054,0,119.467V179.2     c0,81.348,63.718,145.067,145.067,145.067c4.71,0,8.533-3.823,8.533-8.533s-3.823-8.533-8.533-8.533     c-71.774,0-128-56.226-128-128v-59.733h17.067c1.212,0,3.311,0.811,4.207,3.174l17.067,42.667     c1.297,3.234,4.437,5.359,7.927,5.359h296.934l6.92,27.674c0.085,0.333,0.188,0.666,0.307,0.99     c5.35,13.901,16.648,22.536,29.483,22.536h21.154c4.71,0,8.533-3.823,8.533-8.533s-3.823-8.533-8.533-8.533h-21.154     c-7.868,0-11.87-7.458-13.372-11.145l-5.743-22.989h23.202c34.825,0,42.479,42.291,42.786,44.075     c0.683,4.105,4.241,7.125,8.414,7.125c23.526,0,42.667,19.14,42.667,42.667s-19.14,42.667-42.667,42.667H313.054l10.394-21.948     c2.014-4.258,0.196-9.344-4.062-11.366c-4.25-2.005-9.344-0.205-11.366,4.062l-76.843,162.227     c-0.93,2.031-3.541,3.558-4.779,3.558h-38.665v-153.6H281.6c4.71,0,8.533-3.823,8.533-8.533s-3.823-8.533-8.533-8.533H179.2     c-4.71,0-8.533,3.823-8.533,8.533v162.133c0,9.412,7.654,17.067,17.067,17.067h38.665c8.158,0,16.691-5.683,20.25-13.414     l58.317-123.119h147.302c32.939,0,59.733-26.795,59.733-59.733C512,233.95,488.892,208.649,459.213,205.201z" style="fill: rgb(83, 104, 126);"></path>
                      <path d="M238.933,204.8c0-9.412-7.654-17.067-17.067-17.067c-9.412,0-17.067,7.654-17.067,17.067s7.654,17.067,17.067,17.067     C231.279,221.867,238.933,214.212,238.933,204.8z" style="fill: rgb(83, 104, 126);"></path>
                    </g>
                  </g>
                </g>
              </svg>
            </div>

          </div>

          <div class="">
            <p class="option-info">I am travelling to</p>

            <select id="select-destination" class="primary" name="toId">
              <option disabled selected>Select Country</option>
              <?php
              $dbCountries = dbSelect("SELECT * FROM Countries ORDER BY country ASC");
                foreach($dbCountries as $data){ ?>
                  <option value="<?= $data['id']; ?>" <?php if ($toId == $data['id']){echo " selected";}?>><?= $data['country']; ?></option>
                <?php } ?>
            </select>

          </div>

        </div>


        <noscript>
            <input type="submit" class="btn" id="start-search" value="WILL I NEED A VISA?">
        </noscript>

      </form>



      <div id="search-result">
        <?php include($_SERVER['DOCUMENT_ROOT'].'/result.inc.php'); ?>
      </div>

      <div class="footer">
        <div class="uglyadspace" style="width:50%; left:40%; position:relative;z-index:10">
          <!-- INSERT AD HERE -->
        </div>
      </div>


      <div style="position: absolute; height: 14em; left: 0; width: 100%; bottom: 0; background:; overflow: hidden;">
        <div style="position: relative; width: 100%; height: 100%;">
          <svg xmlns="http://www.w3.org/2000/svg" id="Capa_1" style="position: absolute; left: -2em; bottom: -6em; z-index: 1; width: 25%; max-height: 22em" stroke="#f2e3bc" stroke-width="10" viewBox="0 0 548.176 548.176" x="0px" y="0px" width="30%" xmlns:xml="http://www.w3.org/XML/1998/namespace" xml:space="preserve" version="1.1">
            <g>
              <path fill="#53687e" d="M 524.183 297.065 c -15.985 -19.893 -36.265 -32.691 -60.815 -38.399 c 7.81 -11.993 11.704 -25.126 11.704 -39.399 c 0 -20.177 -7.139 -37.401 -21.409 -51.678 c -14.273 -14.272 -31.498 -21.411 -51.675 -21.411 c -18.271 0 -34.071 5.901 -47.39 17.703 c -11.225 -27.028 -29.075 -48.917 -53.529 -65.667 c -24.46 -16.746 -51.728 -25.125 -81.802 -25.125 c -40.349 0 -74.802 14.279 -103.353 42.83 c -28.553 28.544 -42.825 62.999 -42.825 103.351 c 0 2.856 0.191 6.945 0.571 12.275 c -22.078 10.279 -39.876 25.838 -53.389 46.686 C 6.759 299.067 0 322.055 0 347.18 c 0 35.211 12.517 65.333 37.544 90.359 c 25.028 25.033 55.15 37.548 90.362 37.548 h 310.636 c 30.259 0 56.096 -10.715 77.512 -32.121 c 21.413 -21.412 32.121 -47.249 32.121 -77.515 C 548.172 339.757 540.174 316.952 524.183 297.065 Z" />
            </g>
          </svg>

          <svg xmlns="http://www.w3.org/2000/svg" id="Capa_1" style="position: absolute; left: 20%; bottom: -7em; z-index: 2; transform: rotate(360deg); width: 20%; max-height: 18em" viewBox="0 0 956.699 956.699" x="0px" y="0px" width="18%" xmlns:xml="http://www.w3.org/XML/1998/namespace" xml:space="preserve" version="1.1">
            <g>
              <path fill="#53687e" d="M 782.699 413.199 c -0.199 0 -0.299 0 -0.5 0 c -7.699 -121.7 -108.898 -218 -232.5 -218 c -114.099 0 -209 82 -229.099 190.2 c -2.601 -0.1 -5.3 -0.2 -7.9 -0.2 c -85 0 -156.7 56.3 -180.1 133.6 c -3.6 -0.299 -7.3 -0.5 -11 -0.5 c -67.1 0 -121.6 54.4 -121.6 121.6 C 0 707.1 54.4 761.5 121.5 761.5 c 1 0 661.1 0 661.1 0 c 96.201 0 174.1 -78 174.1 -174.102 C 956.699 491.299 878.9 413.199 782.699 413.199 Z" />
            </g>
          </svg>

          <svg xmlns="http://www.w3.org/2000/svg" id="Capa_1" style="position: absolute; right: -1em; bottom: -4em; width: 18%; max-height: 16em" viewBox="0 0 956.699 956.699" x="0px" y="0px" width="18%" xmlns:xml="http://www.w3.org/XML/1998/namespace" xml:space="preserve" version="1.1">
            <g>
              <path fill="#53687e" d="M 782.699 413.199 c -0.199 0 -0.299 0 -0.5 0 c -7.699 -121.7 -108.898 -218 -232.5 -218 c -114.099 0 -209 82 -229.099 190.2 c -2.601 -0.1 -5.3 -0.2 -7.9 -0.2 c -85 0 -156.7 56.3 -180.1 133.6 c -3.6 -0.299 -7.3 -0.5 -11 -0.5 c -67.1 0 -121.6 54.4 -121.6 121.6 C 0 707.1 54.4 761.5 121.5 761.5 c 1 0 661.1 0 661.1 0 c 96.201 0 174.1 -78 174.1 -174.102 C 956.699 491.299 878.9 413.199 782.699 413.199 Z" />
            </g>
          </svg>

          <svg xmlns="http://www.w3.org/2000/svg" id="Capa_1" style="z-index: 0; position: absolute; left: 18%; bottom: 1em; transform: rotate(8deg); width: 15%; max-height: 18em" viewBox="0 0 612.001 612.001" x="0px" y="0px" width="19%" xmlns:xml="http://www.w3.org/XML/1998/namespace" xml:space="preserve" version="1.1">
            <g>
              <path fill="#53687e" d="M 374.778 173.493 l -118.823 -6.317 c -1.379 -0.074 -2.767 0.236 -3.987 0.894 l -65.454 35.305 c -1.988 1.073 -3.394 2.982 -3.826 5.2 c -0.433 2.219 0.152 4.516 1.591 6.257 l 33.672 40.733 c 0.327 -0.247 0.661 -0.486 1.036 -0.683 L 374.778 173.493 Z" />
              <path fill="#53687e" d="M 609.246 131.32 c -0.059 -0.126 -0.12 -0.251 -0.188 -0.373 c -4.695 -8.796 -15.308 -19.28 -39.184 -19.28 c -25.109 0 -52.433 11.402 -53.584 11.888 c -66.229 26.386 -377.957 190.42 -377.957 190.42 l -74.648 -40.22 c -2.208 -1.189 -4.857 -1.206 -7.076 -0.047 L 4.055 301.156 c -2.217 1.156 -3.716 3.337 -4.005 5.821 c -0.286 2.484 0.67 4.949 2.562 6.585 l 128.431 111.028 c 2.347 2.024 5.688 2.416 8.432 0.981 l 125.416 -65.436 l 18.977 133.711 c 0.346 2.444 1.865 4.564 4.067 5.676 c 1.072 0.542 2.241 0.813 3.409 0.813 c 1.23 0 2.461 -0.301 3.576 -0.9 c 13.331 -7.169 21.652 -11.707 29.697 -16.098 c 8.197 -4.473 16.674 -9.099 30.389 -16.467 c 1.468 -0.787 2.631 -2.038 3.314 -3.555 l 89.258 -198.554 l 91.751 -47.902 C 582.228 195.076 623.122 161.163 609.246 131.32 Z" />
            </g>
          </svg>
        </div>
      </div>

    </div>
  </div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script src="mainJavascript.js"></script>
</body>
</html>
