part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author kile / http://kile.stravaganza.org/
 * @author philogb / http://blog.thejit.org/
 * @author mikael emtinger / http://gomo.se/
 * @author egraether / http://egraether.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Vector3 extends SIMDVector<Vector3> implements IVector3 {
  Float32x4 _v;

  Vector3( [num x = 0, num y = 0, num z = 0] ) : super(x, y, z);

  Vector3 setValues( num x, num y, num z ) => _setValues(x, y, z, 0.0);

  Vector3 clone() => new Vector3( x, y, z );

  toString() => "($x, $y, $z)";

  Vector3 getPositionFromMatrix( m ) {
    setValues(
      m.elements[12],
      m.elements[13],
      m.elements[14]);

    return this;

  }

  Vector3 setEulerFromRotationMatrix( m, [String order = 'XYZ'] ) {

    // assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)

    // clamp, to handle numerical problems

    var clamp = ( x ) => Math.min( Math.max( x, -1 ), 1 );

    var x = this.x, y = this.y, z = this.z;

    var te = m.elements;
    var m11 = te[0], m12 = te[4], m13 = te[8];
    var m21 = te[1], m22 = te[5], m23 = te[9];
    var m31 = te[2], m32 = te[6], m33 = te[10];

    if ( order == 'XYZ' ) {

      y = Math.asin( clamp( m13 ) );

      if (  m13.abs() < 0.99999 ) {

        x = Math.atan2( - m23, m33 );
        z = Math.atan2( - m12, m11 );

      } else {

        x = Math.atan2( m21, m22 );
        z = 0;

      }

    } else if ( order == 'YXZ' ) {

      x = Math.asin( - clamp( m23 ) );

      if ( m23.abs() < 0.99999 ) {

        y = Math.atan2( m13, m33 );
        z = Math.atan2( m21, m22 );

      } else {

        y = Math.atan2( - m31, m11 );
        z = 0;

      }

    } else if ( order == 'ZXY' ) {

      x = Math.asin( clamp( m32 ) );

      if ( m32.abs() < 0.99999 ) {

        y = Math.atan2( - m31, m33 );
        z = Math.atan2( - m12, m22 );

      } else {

        y = 0;
        z = Math.atan2( m13, m11 );

      }

    } else if ( order == 'ZYX' ) {

      y = Math.asin( - clamp( m31 ) );

      if (m31.abs() < 0.99999 ) {

        x = Math.atan2( m32, m33 );
        z = Math.atan2( m21, m11 );

      } else {

        x = 0;
        z = Math.atan2( - m12, m22 );

      }

    } else if ( order == 'YZX' ) {

      z = Math.asin( clamp( m21 ) );

      if ( m21.abs() < 0.99999 ) {

        x = Math.atan2( - m23, m22 );
        y = Math.atan2( - m31, m11 );

      } else {

        x = 0;
        y = Math.atan2( m31, m33 );

      }

    } else if ( order == 'XZY' ) {

      z = Math.asin( - clamp( m12 ) );

      if ( m12.abs() < 0.99999 ) {

        x = Math.atan2( m32, m22 );
        y = Math.atan2( m13, m11 );

      } else {

        x = Math.atan2( - m13, m33 );
        y = 0;

      }

    }

    return setValues(x, y, z);

  }

  setEulerFromQuaternion( q, [String order = 'XYZ'] ) {

    // q is assumed to be normalized

    // clamp, to handle numerical problems

    var clamp = ( x ) => Math.min( Math.max( x, -1 ), 1 );

    // http://www.mathworks.com/matlabcentral/fileexchange/20696-function-to-convert-between-dcm-euler-angles-quaternions-and-euler-vectors/content/SpinCalc.m

    var x = this.x, y = this.y, z = this.z;

    var sqx = q.x * q.x;
    var sqy = q.y * q.y;
    var sqz = q.z * q.z;
    var sqw = q.w * q.w;

    if ( order == 'XYZ' ) {

      x = Math.atan2( 2 * ( q.x * q.w - q.y * q.z ), ( sqw - sqx - sqy + sqz ) );
      y = Math.asin(  clamp( 2 * ( q.x * q.z + q.y * q.w ) ) );
      z = Math.atan2( 2 * ( q.z * q.w - q.x * q.y ), ( sqw + sqx - sqy - sqz ) );

    } else if ( order ==  'YXZ' ) {

      x = Math.asin(  clamp( 2 * ( q.x * q.w - q.y * q.z ) ) );
      y = Math.atan2( 2 * ( q.x * q.z + q.y * q.w ), ( sqw - sqx - sqy + sqz ) );
      z = Math.atan2( 2 * ( q.x * q.y + q.z * q.w ), ( sqw - sqx + sqy - sqz ) );

    } else if ( order == 'ZXY' ) {

      x = Math.asin(  clamp( 2 * ( q.x * q.w + q.y * q.z ) ) );
      y = Math.atan2( 2 * ( q.y * q.w - q.z * q.x ), ( sqw - sqx - sqy + sqz ) );
      z = Math.atan2( 2 * ( q.z * q.w - q.x * q.y ), ( sqw - sqx + sqy - sqz ) );

    } else if ( order == 'ZYX' ) {

      x = Math.atan2( 2 * ( q.x * q.w + q.z * q.y ), ( sqw - sqx - sqy + sqz ) );
      y = Math.asin(  clamp( 2 * ( q.y * q.w - q.x * q.z ) ) );
      z = Math.atan2( 2 * ( q.x * q.y + q.z * q.w ), ( sqw + sqx - sqy - sqz ) );

    } else if ( order == 'YZX' ) {

      x = Math.atan2( 2 * ( q.x * q.w - q.z * q.y ), ( sqw - sqx + sqy - sqz ) );
      y = Math.atan2( 2 * ( q.y * q.w - q.x * q.z ), ( sqw + sqx - sqy - sqz ) );
      z = Math.asin(  clamp( 2 * ( q.x * q.y + q.z * q.w ) ) );

    } else if ( order == 'XZY' ) {

      x = Math.atan2( 2 * ( q.x * q.w + q.y * q.z ), ( sqw - sqx + sqy - sqz ) );
      y = Math.atan2( 2 * ( q.x * q.z + q.y * q.w ), ( sqw + sqx - sqy - sqz ) );
      z = Math.asin(  clamp( 2 * ( q.z * q.w - q.x * q.y ) ) );

    }

    return setValues(x, y, z);

  }


  Vector3 getScaleFromMatrix( m ) {

    var sx = setValues( m.elements[0], m.elements[1], m.elements[2] ).length();
    var sy = setValues( m.elements[4], m.elements[5], m.elements[6] ).length();
    var sz = setValues( m.elements[8], m.elements[9], m.elements[10] ).length();

    return setValues(sx, sy, sz);
  }
}
