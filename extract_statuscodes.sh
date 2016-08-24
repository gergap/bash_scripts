#!/bin/sh
# Creates OPC UA statuscodes map from header file with error defines

echo "#ifndef __OPCUA_ERRORMESSAGES_H_"
echo "#define __OPCUA_ERRORMESSAGES_H_"
echo ""
echo "void fillMapWithErrorMessages(QMap<quint32, QString> &map)"
echo "{"
echo "    map[0x00000000] = \"Good (0x00000000)\";"
echo "    map[0x40000000] = \"Uncertain (0x40000000)\";"
echo "    map[0x80000000] = \"Bad (0x80000000)\";"
cat opcua_statuscodes.h | grep "#define OpcUa_" | sed -e 's/#define OpcUa_\(\w*\) \(0x[0-9A-Z]*\)/    map[\2] = "\1 (\2)";/'
cat opcua_stackstatuscodes.h | grep "#define OpcUa_" | sed -e 's/#define OpcUa_\(\w*\) \(0x[0-9A-Z]*\)/    map[\2] = "\1 (\2)";/'
echo "}"
echo ""
echo "#endif"
echo ""

