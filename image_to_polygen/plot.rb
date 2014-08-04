#!/usr/bin/env ruby

POINTS = []
ARGF.each_line do |x|
  POINTS << x.strip.split(/\s+/)
end

puts <<ENDSVG
<svg xmlns="http://www.w3.org/2000/svg">
<rect x="0" y="0" width="800" height="800" style="fill: black;"/>
#{POINTS.map { |p| "<rect x=\"#{p[0]}\" y=\"#{p[1]}\" width=\"1\" height=\"1\" style=\"fill: white;\"/>" }.join("\n")}
</svg>
ENDSVG
