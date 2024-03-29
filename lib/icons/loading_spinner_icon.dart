import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

class LoadingSpinnerIcon extends StatelessWidget {
  Color? color;
  LoadingSpinnerIcon({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
<?xml version="1.0" encoding="iso-8859-1"?>
<!-- Generator: Adobe Illustrator 16.0.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="512px" height="512px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve">
<g>
	<path d="M96,255.006c0-6.09,0.352-12.098,1.015-18.011l-92.49-30.052C1.567,222.513,0,238.575,0,255.006
		c0,73.615,31.083,139.96,80.827,186.662l57.142-78.647C111.907,334.557,96,296.641,96,255.006z M416,255.006
		c0,41.634-15.906,79.55-41.969,108.014l57.143,78.647C480.916,394.967,512,328.621,512,255.006c0-16.431-1.566-32.493-4.523-48.063
		l-92.49,30.052C415.648,242.909,416,248.917,416,255.006z M288,98.21c45.967,9.331,84.771,38.371,107.225,77.913l92.49-30.051
		C451.115,68.362,376.594,12.042,288,0.994V98.21z M116.775,176.123c22.453-39.542,61.258-68.582,107.225-77.913V0.994
		C135.406,12.042,60.885,68.362,24.287,146.071L116.775,176.123z M322.277,400.67c-20.195,9.205-42.635,14.336-66.277,14.336
		c-23.642,0-46.083-5.131-66.277-14.334l-57.146,78.654c36.603,20.184,78.668,31.68,123.423,31.68
		c44.756,0,86.82-11.496,123.424-31.68L322.277,400.67z"/>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
<g>
</g>
</svg>


''',
      color: color,
    );
  }
}
