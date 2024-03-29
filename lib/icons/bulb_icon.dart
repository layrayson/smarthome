import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

class BulbIcon extends StatelessWidget {
  final Color color;
  const BulbIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
<?xml version="1.0" encoding="iso-8859-1"?>
<!-- Generator: Adobe Illustrator 16.0.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="485.213px" height="485.212px" viewBox="0 0 485.213 485.212" style="enable-background:new 0 0 485.213 485.212;"
	 xml:space="preserve">
<g>
	<path d="M394.235,151.628c0,82.449-49.695,92.044-59.021,181.956c0,8.382-6.785,15.163-15.168,15.163H165.161
		c-8.379,0-15.161-6.781-15.161-15.163h-0.028c-9.299-89.912-58.994-99.507-58.994-181.956C90.978,67.878,158.855,0,242.606,0
		S394.235,67.878,394.235,151.628z M318.423,363.906H166.794c-8.384,0-15.166,6.786-15.166,15.168
		c0,8.378,6.782,15.163,15.166,15.163h151.628c8.378,0,15.163-6.785,15.163-15.163C333.586,370.692,326.801,363.906,318.423,363.906
		z M318.423,409.396H166.794c-8.384,0-15.166,6.786-15.166,15.163c0,8.383,6.782,15.168,15.166,15.168h151.628
		c8.378,0,15.163-6.785,15.163-15.168C333.586,416.182,326.801,409.396,318.423,409.396z M212.282,485.212h60.65
		c16.76,0,30.322-13.562,30.322-30.326h-121.3C181.955,471.65,195.518,485.212,212.282,485.212z"/>
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
