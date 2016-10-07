	<?xml version="1.0" encoding="UTF-8"?>
	<configuration>
	    <system.webServer>
	        <rewrite>
	            <rules>
	                <rule name="Virtual Directory Rewrite">
	                    <match url=".*" />
	                    <conditions>
	                        <add input="{SUBDOMAINS:{HTTP_HOST}}" pattern="(.+)" />
	                    </conditions>
	                    <action type="Rewrite" url="{C:1}{REQUEST_URI}" appendQueryString="false" />
	                </rule>
	            </rules>
	            <rewriteMaps>
	                <rewriteMap name="SUBDOMAINS">
	                    <add key="one.com" value="one" />
	                    <add key="two.com" value="two" />
						<add key="three.com" value="three" />
	                </rewriteMap>
	            </rewriteMaps>
	        </rewrite>
	    </system.webServer>
	</configuration>